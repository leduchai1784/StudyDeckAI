import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app/theme.dart';
import '../../../../shared/widgets/app_back_button.dart';
import '../../../ai_tutor/services/gemini_ai_tutor_service.dart';
import '../models/speaking_shadowing_model.dart';

class SpeakingShadowingScreen extends StatefulWidget {
  final ShadowingExercise exercise;

  const SpeakingShadowingScreen({
    super.key,
    required this.exercise,
  });

  @override
  State<SpeakingShadowingScreen> createState() =>
      _SpeakingShadowingScreenState();
}

class _SpeakingShadowingScreenState extends State<SpeakingShadowingScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _currentIndex = 0;
  bool _isPlayingNative = false;
  bool _isPlayingUser = false;
  bool _isRecording = false;
  int _recordSeconds = 0;
  DateTime? _recordStartTime;
  Timer? _recordTimer;
  Timer? _recordTimeoutTimer;
  Timer? _safetyTimer;
  double _speechRate = 0.44; // 1.0x normal, 0.35 is 0.75x slow
  String _selectedAccent = 'en-US'; // Default to en-US for 100% Android compatibility

  String? _recordedFilePath;
  ShadowingEvaluationResult? _evaluationResult;
  ShadowingWordFeedback? _selectedWordFeedback;
  bool _isAnalyzing = false;
  bool _showTranslation = true;

  @override
  void initState() {
    super.initState();
    _initTts();
    _initAudioPlayer();

    // Auto-play sentence on screen open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _playNativeAudio();
      }
    });
  }

  Future<void> _initTts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('studydeck_listening_accent');
      if (saved != null && (saved == 'en-GB' || saved == 'en-US')) {
        _selectedAccent = saved;
      }

      await _flutterTts.awaitSpeakCompletion(true);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(_speechRate);

      // Verify language availability, fallback to en-US if en-GB is not installed on device
      final isAvail = await _flutterTts.isLanguageAvailable(_selectedAccent);
      if (isAvail != true && _selectedAccent == 'en-GB') {
        _selectedAccent = 'en-US';
      }
      await _flutterTts.setLanguage(_selectedAccent);

      _flutterTts.setStartHandler(() {
        if (mounted) setState(() => _isPlayingNative = true);
      });
      _flutterTts.setCompletionHandler(() {
        _safetyTimer?.cancel();
        if (mounted) setState(() => _isPlayingNative = false);
      });
      _flutterTts.setCancelHandler(() {
        _safetyTimer?.cancel();
        if (mounted) setState(() => _isPlayingNative = false);
      });
      _flutterTts.setErrorHandler((dynamic msg) {
        _safetyTimer?.cancel();
        if (mounted) setState(() => _isPlayingNative = false);
      });
    } catch (_) {}
  }

  void _initAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      if (state == PlayerState.completed || state == PlayerState.stopped) {
        setState(() => _isPlayingUser = false);
      } else if (state == PlayerState.playing) {
        setState(() => _isPlayingUser = true);
      }
    });
  }

  @override
  void dispose() {
    _safetyTimer?.cancel();
    _recordTimer?.cancel();
    _recordTimeoutTimer?.cancel();
    try {
      _flutterTts.stop();
      _audioPlayer.stop();
      _audioPlayer.dispose();
      _audioRecorder.dispose();
    } catch (_) {}
    super.dispose();
  }

  ShadowingSentence get _currentSentence =>
      widget.exercise.sentences[_currentIndex];

  Future<void> _playNativeAudio() async {
    try {
      await _audioPlayer.stop();
      await _flutterTts.stop();
      _safetyTimer?.cancel();

      if (!mounted) return;
      setState(() {
        _isPlayingNative = true;
        _isPlayingUser = false;
      });

      // Safety timeout: reset status if TTS completion callback does not trigger
      final wordCount = _currentSentence.englishText.split(' ').length;
      final maxSec = (wordCount * 0.8).clamp(4.0, 15.0).toInt();
      _safetyTimer = Timer(Duration(seconds: maxSec), () {
        if (mounted && _isPlayingNative) {
          setState(() => _isPlayingNative = false);
        }
      });

      await _flutterTts.setLanguage(_selectedAccent);
      await _flutterTts.setSpeechRate(_speechRate);
      final result = await _flutterTts.speak(_currentSentence.englishText);

      // If speak returned 0 (error on Android), fallback to en-US immediately
      if (result == 0 && _selectedAccent != 'en-US') {
        _selectedAccent = 'en-US';
        await _flutterTts.setLanguage('en-US');
        await _flutterTts.speak(_currentSentence.englishText);
      }
    } catch (_) {
      _safetyTimer?.cancel();
      if (mounted) setState(() => _isPlayingNative = false);
    }
  }

  Future<void> _stopNativeAudio() async {
    _safetyTimer?.cancel();
    try {
      await _flutterTts.stop();
    } catch (_) {}
    if (mounted) {
      setState(() => _isPlayingNative = false);
    }
  }

  Future<void> _playRecordedAudio() async {
    if (_recordedFilePath == null) return;
    try {
      await _flutterTts.stop();
      if (_isPlayingUser) {
        await _audioPlayer.stop();
        setState(() => _isPlayingUser = false);
      } else {
        setState(() {
          _isPlayingUser = true;
          _isPlayingNative = false;
        });
        await _audioPlayer.play(DeviceFileSource(_recordedFilePath!));
      }
    } catch (_) {
      if (mounted) setState(() => _isPlayingUser = false);
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Row(
          children: [
            Icon(Icons.mic_off_rounded, color: Color(0xFFEF4444), size: 24),
            SizedBox(width: 8),
            Text(
              'Cần Quyền Microphone',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.brandTextPrimary,
              ),
            ),
          ],
        ),
        content: const Text(
          'StudyDeck AI cần quyền Microphone để thu và phân tích phát âm câu nói của bạn. Vui lòng cấp quyền trong phần Cài đặt thiết bị để tiếp tục bài học.',
          style: TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Để sau', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _startRecording();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.brandPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Future<void> _startRecording() async {
    try {
      await _flutterTts.stop();
      await _audioPlayer.stop();

      final hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        if (!mounted) return;
        _showPermissionDialog();
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final path =
          '${tempDir.path}/shadowing_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: path,
      );

      setState(() {
        _isRecording = true;
        _recordSeconds = 0;
        _recordStartTime = DateTime.now();
        _recordedFilePath = null;
        _evaluationResult = null;
        _selectedWordFeedback = null;
      });

      _recordTimer?.cancel();
      _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() => _recordSeconds++);
      });

      // Kịch bản 7: Tự động ngắt khi chạm mốc 30 giây (Timeout safety)
      _recordTimeoutTimer?.cancel();
      _recordTimeoutTimer = Timer(const Duration(seconds: 30), () {
        if (mounted && _isRecording) {
          _stopRecording(isTimeout: true);
        }
      });
    } catch (_) {
      setState(() {
        _isRecording = true;
        _recordSeconds = 0;
        _recordStartTime = DateTime.now();
      });
      _recordTimer?.cancel();
      _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() => _recordSeconds++);
      });
    }
  }

  Future<void> _stopRecording({bool isTimeout = false}) async {
    _recordTimer?.cancel();
    _recordTimeoutTimer?.cancel();

    final elapsedMs = _recordStartTime != null
        ? DateTime.now().difference(_recordStartTime!).inMilliseconds
        : (_recordSeconds * 1000);

    String? path;
    try {
      path = await _audioRecorder.stop();
    } catch (_) {}

    // Kịch bản 2: Ghi âm quá ngắn (< 1.5 giây / 1500ms)
    if (elapsedMs < 1500) {
      if (path != null) {
        try {
          final f = File(path);
          if (await f.exists()) await f.delete();
        } catch (_) {}
      }

      if (mounted) {
        setState(() {
          _isRecording = false;
          _isAnalyzing = false;
          _recordedFilePath = null;
          _recordSeconds = 0;
          _selectedWordFeedback = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Thời gian ghi âm quá ngắn (< 1.5s). Vui lòng nhấn Micro và đọc trọn vẹn cả câu nhé!',
                    style: TextStyle(fontSize: 12.5),
                  ),
                ),
              ],
            ),
            backgroundColor: Color(0xFF64748B),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    if (isTimeout && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã tự động kết thúc ghi âm sau 30 giây!'),
          backgroundColor: Color(0xFF0284C7),
          duration: Duration(seconds: 2),
        ),
      );
    }

    setState(() {
      _isRecording = false;
      _recordedFilePath = path;
      _isAnalyzing = true;
      _selectedWordFeedback = null;
    });

    if (path == null) {
      setState(() => _isAnalyzing = false);
      return;
    }

    // Gọi Gemini Multimodal Audio Evaluation phân tích âm thanh thật
    final result = await GeminiAiTutorService().evaluateShadowingAudio(
      audioFilePath: path,
      sentence: _currentSentence,
      durationSeconds: (elapsedMs / 1000).round(),
    );

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _evaluationResult = result;
      });
    }
  }

  void _nextSentence() {
    if (_currentIndex < widget.exercise.sentences.length - 1) {
      setState(() {
        _currentIndex++;
        _evaluationResult = null;
        _recordedFilePath = null;
        _isRecording = false;
        _recordSeconds = 0;
        _selectedWordFeedback = null;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _playNativeAudio();
      });
    } else {
      _showCompletionDialog();
    }
  }

  void _retryCurrentSentence() {
    setState(() {
      _evaluationResult = null;
      _recordedFilePath = null;
      _isRecording = false;
      _recordSeconds = 0;
      _selectedWordFeedback = null;
    });
    _playNativeAudio();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Row(
          children: [
            Icon(Icons.stars_rounded, color: Color(0xFFF59E0B), size: 28),
            SizedBox(width: 8),
            Text(
              'Hoàn Thành Bài Luyện!',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppTheme.brandTextPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bạn đã hoàn thành xuất sắc ${widget.exercise.sentences.length} câu Shadowing cho chủ đề "${widget.exercise.title}".',
              style: const TextStyle(fontSize: 13.5, color: Color(0xFF475569)),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF86EFAC)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: Color(0xFF16A34A), size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ngữ điệu tự nhiên • Độ chuẩn xác trung bình ~90%',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF166534),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _currentIndex = 0;
                _evaluationResult = null;
                _recordedFilePath = null;
              });
              _playNativeAudio();
            },
            child: const Text('Luyện lại từ đầu'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.brandPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Hoàn tất'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sentence = _currentSentence;
    final totalSentences = widget.exercise.sentences.length;

    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const AppBackButton(),
        title: Text(
          widget.exercise.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.brandTextPrimary,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.tintIndigoBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppTheme.brandPrimary.withValues(alpha: 0.2)),
            ),
            child: Text(
              'Câu ${_currentIndex + 1} / $totalSentences',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.brandPrimary,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Linear Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_currentIndex + 1) / totalSentences,
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppTheme.brandPrimary),
                minHeight: 5,
              ),
            ),
            const SizedBox(height: 14),

            // 1. Thẻ Câu Mẫu của Người Bản Xứ (Native Speaker Audio Box)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row Header: Loa người bản xứ + Tốc độ nói
                  Row(
                    children: [
                      // Accent tag: Tap to toggle between US and UK
                      GestureDetector(
                        onTap: () async {
                          final next = _selectedAccent == 'en-US' ? 'en-GB' : 'en-US';
                          setState(() => _selectedAccent = next);
                          try {
                            await _flutterTts.setLanguage(next);
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString('studydeck_listening_accent', next);
                          } catch (_) {}
                          _playNativeAudio();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.volume_up_rounded,
                                  size: 14, color: AppTheme.brandPrimary),
                              const SizedBox(width: 4),
                              Text(
                                _selectedAccent == 'en-GB'
                                    ? 'GIỌNG ANH (UK)'
                                    : 'GIỌNG MỸ (US)',
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.brandPrimary,
                                ),
                              ),
                              const SizedBox(width: 3),
                              const Icon(Icons.sync_rounded,
                                  size: 11, color: AppTheme.brandPrimary),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),

                      // Nút ẩn/hiện dịch
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showTranslation = !_showTranslation;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            _showTranslation
                                ? Icons.translate_rounded
                                : Icons.g_translate_rounded,
                            size: 14,
                            color: const Color(0xFF475569),
                          ),
                        ),
                      ),

                      // Nút chọn tốc độ 0.75x hoặc 1.0x
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _speechRate = (_speechRate == 0.44) ? 0.35 : 0.44;
                          });
                          _playNativeAudio();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _speechRate == 0.44 ? 'Tốc độ: 1.0x' : 'Tốc độ: 0.75x (Chậm)',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Câu Tiếng Anh
                  Text(
                    sentence.englishText,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.brandTextPrimary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Phiên âm quốc tế IPA (sử dụng AppTheme.ipaStyle để tránh lỗi font ô vuông)
                  Text(
                    sentence.phonetic,
                    style: AppTheme.ipaStyle(
                      fontSize: 13,
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                  // Dịch nghĩa tiếng Việt (toggle)
                  if (_showTranslation) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.translate_rounded,
                              size: 14, color: Color(0xFF64748B)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              sentence.vietnameseTranslation,
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: Color(0xFF334155),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),

                  // Nút Bấm Phát Lại Giọng Bản Xứ (Click để nghe hoặc bấm lại để dừng)
                  OutlinedButton.icon(
                    onPressed: _isPlayingNative
                        ? _stopNativeAudio
                        : _playNativeAudio,
                    icon: Icon(
                      _isPlayingNative
                          ? Icons.stop_rounded
                          : Icons.play_arrow_rounded,
                      size: 18,
                      color: AppTheme.brandPrimary,
                    ),
                    label: Text(
                      _isPlayingNative
                          ? 'Dừng phát'
                          : 'Nghe lại câu mẫu',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brandPrimary,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFC7D2FE)),
                      backgroundColor: const Color(0xFFF5F3FF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Khu Vực Thu Âm Giọng Nói (Microphone Recording Section)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isRecording
                      ? const Color(0xFFFCA5A5)
                      : const Color(0xFFE2E8F0),
                  width: _isRecording ? 1.5 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    _isRecording
                        ? 'Đang lắng nghe... Hãy nhại lại theo câu mẫu!'
                        : (_evaluationResult != null
                            ? 'Đã ghi âm xong! Xem kết quả đối chiếu bên dưới.'
                            : 'Nhấn nút Micro để bắt đầu ghi âm Shadowing'),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _isRecording
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Micro Button
                  GestureDetector(
                    onTap: () {
                      if (_isRecording) {
                        _stopRecording();
                      } else {
                        _startRecording();
                      }
                    },
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isRecording
                            ? const Color(0xFFDC2626)
                            : AppTheme.brandPrimary,
                        boxShadow: [
                          BoxShadow(
                            color: (_isRecording
                                    ? const Color(0xFFDC2626)
                                    : AppTheme.brandPrimary)
                                .withValues(alpha: 0.35),
                            blurRadius: _isRecording ? 16 : 8,
                            spreadRadius: _isRecording ? 4 : 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isRecording
                            ? Icons.stop_rounded
                            : Icons.mic_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (_isRecording)
                    Text(
                      '00:0${_recordSeconds < 10 ? '0$_recordSeconds' : _recordSeconds}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDC2626),
                      ),
                    )
                  else
                    Text(
                      _evaluationResult != null
                          ? 'Bấm Micro nếu muốn ghi âm lại câu này'
                          : 'Nói to, rõ ràng và bắt chước ngữ điệu ngắt nghỉ',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Kết Quả Phân Tích & Đối Chiếu Giọng Kép (Word Analysis & Dual Playback)
            if (_isAnalyzing)
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Column(
                  children: [
                    CircularProgressIndicator(color: AppTheme.brandPrimary),
                    SizedBox(height: 12),
                    Text(
                      'AI đang phân tích độ chuẩn phát âm & ngữ điệu...',
                      style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              )
            else if (_evaluationResult != null) ...[
              // Kịch bản 3: Không phát hiện giọng đọc (No Speech Detected)
              if (_evaluationResult!.noSpeechDetected)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.mic_off_rounded,
                          color: Color(0xFFD97706), size: 36),
                      const SizedBox(height: 8),
                      const Text(
                        'Không phát hiện giọng đọc tiếng Anh',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF92400E),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _evaluationResult!.aiFeedback,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF78350F),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton.icon(
                        onPressed: _startRecording,
                        icon: const Icon(Icons.mic_rounded, size: 16),
                        label: const Text('Thử ghi âm lại'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD97706),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              // Kịch bản 6: Bản thu âm chưa khớp câu mẫu (< 40% accuracy hoặc lạc đề)
              else if (_evaluationResult!.isLowMatch)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFECACA)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: Color(0xFFDC2626), size: 36),
                      const SizedBox(height: 8),
                      const Text(
                        'Nội dung thu âm chưa khớp câu mẫu',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF991B1B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _evaluationResult!.aiFeedback,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF7F1D1D),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                setState(() => _speechRate = 0.35);
                                _playNativeAudio();
                              },
                              icon: const Icon(Icons.slow_motion_video_rounded,
                                  size: 16),
                              label: const Text('Nghe chậm 0.75x'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF991B1B),
                                side:
                                    const BorderSide(color: Color(0xFFFCA5A5)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _startRecording,
                              icon: const Icon(Icons.mic_rounded, size: 16),
                              label: const Text('Ghi âm lại'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDC2626),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              // Kịch bản 4 & 5: Đọc bình thường (Chuẩn hoặc cần chỉnh sửa)
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _evaluationResult!.accuracyScore >= 80
                          ? const Color(0xFF86EFAC)
                          : const Color(0xFFCBD5E1),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Scores: Phát âm, Hoàn thiện, Ngữ điệu
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          // Accuracy Score
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle_rounded,
                                    size: 16, color: Color(0xFF16A34A)),
                                const SizedBox(width: 6),
                                Text(
                                  'Phát âm: ${_evaluationResult!.accuracyScore.toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF15803D),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Completeness Score
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.format_list_bulleted_rounded,
                                    size: 16, color: Color(0xFFD97706)),
                                const SizedBox(width: 6),
                                Text(
                                  'Đầy đủ: ${_evaluationResult!.completenessScore.toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB45309),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Fluency / Intonation Score
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.tintIndigoBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.waves_rounded,
                                    size: 16, color: AppTheme.brandPrimary),
                                const SizedBox(width: 6),
                                Text(
                                  'Ngữ điệu: ${_evaluationResult!.fluencyScore.toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.brandPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Chi Tiết So Khớp Từng Từ
                      Row(
                        children: [
                          const Text(
                            'CHI TIẾT PHÁT ÂM TỪNG TỪ:',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF64748B),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '(Chạm từ để xem hướng dẫn)',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: Colors.blueGrey.shade400,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Word Chips (Interactive)
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: _evaluationResult!.wordFeedbacks.map((fb) {
                          final isSelected = _selectedWordFeedback == fb;
                          final isCorrect = fb.status == ShadowingWordStatus.correct || fb.isMatched;

                          Color bgColor = const Color(0xFFDCFCE7);
                          Color borderColor = const Color(0xFF86EFAC);
                          Color textColor = const Color(0xFF15803D);

                          if (fb.status == ShadowingWordStatus.mispronounced || (!isCorrect && fb.status != ShadowingWordStatus.missing)) {
                            bgColor = const Color(0xFFFEE2E2);
                            borderColor = const Color(0xFFFCA5A5);
                            textColor = const Color(0xFFDC2626);
                          } else if (fb.status == ShadowingWordStatus.missing) {
                            bgColor = const Color(0xFFFEF3C7);
                            borderColor = const Color(0xFFFCD34D);
                            textColor = const Color(0xFFD97706);
                          }

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedWordFeedback = isSelected ? null : fb;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.brandPrimary
                                      : borderColor,
                                  width: isSelected ? 2.0 : 1.0,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppTheme.brandPrimary.withValues(alpha: 0.25),
                                          blurRadius: 4,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                fb.word,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      // Word Inspector Box khi người dùng chạm vào một từ
                      if (_selectedWordFeedback != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    _selectedWordFeedback!.word,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.brandTextPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (_selectedWordFeedback!.phonetic != null &&
                                      _selectedWordFeedback!.phonetic!.isNotEmpty)
                                    Text(
                                      _selectedWordFeedback!.phonetic!,
                                      style: AppTheme.ipaStyle(
                                        fontSize: 12.5,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: (_selectedWordFeedback!.isMatched ||
                                              _selectedWordFeedback!.status == ShadowingWordStatus.correct)
                                          ? const Color(0xFFDCFCE7)
                                          : const Color(0xFFFEE2E2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      (_selectedWordFeedback!.isMatched ||
                                              _selectedWordFeedback!.status == ShadowingWordStatus.correct)
                                          ? 'Phát âm chuẩn'
                                          : 'Cần sửa âm',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.bold,
                                        color: (_selectedWordFeedback!.isMatched ||
                                                _selectedWordFeedback!.status == ShadowingWordStatus.correct)
                                            ? const Color(0xFF15803D)
                                            : const Color(0xFFDC2626),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (_selectedWordFeedback!.tip != null &&
                                  _selectedWordFeedback!.tip!.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.tips_and_updates_rounded,
                                        size: 15, color: Color(0xFFF59E0B)),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        _selectedWordFeedback!.tip!,
                                        style: const TextStyle(
                                          fontSize: 11.5,
                                          color: Color(0xFF334155),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),

                      // Nhận xét từ AI Tutor
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.auto_awesome_rounded,
                                size: 16, color: AppTheme.brandPrimary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _evaluationResult!.aiFeedback,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF334155),
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      const SizedBox(height: 12),

                      // Thanh Đối Chiếu Âm Thanh Kép (Dual Audio Playback)
                      Row(
                        children: [
                          // Nút 1: Nghe lại giọng bản xứ
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _isPlayingNative
                                  ? _stopNativeAudio
                                  : _playNativeAudio,
                              icon: Icon(
                                _isPlayingNative
                                    ? Icons.stop_rounded
                                    : Icons.volume_up_rounded,
                                size: 16,
                                color: const Color(0xFF475569),
                              ),
                              label: Text(
                                _isPlayingNative ? 'Dừng phát' : 'Giọng Bản Xứ',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF475569),
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 9),
                                side: const BorderSide(
                                    color: Color(0xFFCBD5E1)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Nút 2: Nghe lại giọng của bạn
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _recordedFilePath != null
                                  ? _playRecordedAudio
                                  : null,
                              icon: Icon(
                                _isPlayingUser
                                    ? Icons.stop_rounded
                                    : Icons.play_arrow_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                              label: Text(
                                _isPlayingUser
                                    ? 'Đang phát...'
                                    : 'Giọng Của Bạn',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D9488),
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 9),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),

              // Action Buttons: Luyện lại & Sang câu tiếp
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _retryCurrentSentence,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        'Luyện lại câu này',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _nextSentence,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.brandPrimary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        _currentIndex < totalSentences - 1
                            ? 'Câu tiếp theo'
                            : 'Hoàn tất bài luyện',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
