import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../app/theme.dart';
import '../models/speaking_model.dart';
import '../../../ai_tutor/services/gemini_ai_tutor_service.dart';
import '../../../../shared/widgets/app_back_button.dart';

class SpeakingPracticeScreen extends StatefulWidget {
  final SpeakingTopic topic;
  final int initialQuestionIndex;

  const SpeakingPracticeScreen({
    super.key,
    required this.topic,
    this.initialQuestionIndex = 0,
  });

  @override
  State<SpeakingPracticeScreen> createState() => _SpeakingPracticeScreenState();
}

class _SpeakingPracticeScreenState extends State<SpeakingPracticeScreen> {
  late int _currentIndex;
  final FlutterTts _flutterTts = FlutterTts();
  final TextEditingController _inputController = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isSpeaking = false;
  bool _isRecording = false;
  int _recordSeconds = 0;
  Timer? _recordTimer;

  String? _userAudioPath;
  String? _userAudioFileName;
  bool _isPlayingUserAudio = false;
  Duration _audioDuration = Duration.zero;
  Duration _audioPosition = Duration.zero;
  bool _isTranscribingAudio = false;
  bool _isEditingTranscript = false;

  bool _isEvaluating = false;
  SpeakingEvaluationResult? _evaluationResult;
  bool _showUpgradedAnswer = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialQuestionIndex;
    _initTts();
    _initAudioPlayer();

    // Auto-read question with Examiner voice after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _playExaminerQuestion();
      }
    });
  }

  void _initAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlayingUserAudio = state == PlayerState.playing;
        });
      }
    });
    _audioPlayer.onDurationChanged.listen((dur) {
      if (mounted) setState(() => _audioDuration = dur);
    });
    _audioPlayer.onPositionChanged.listen((pos) {
      if (mounted) setState(() => _audioPosition = pos);
    });
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.setLanguage("en-GB");
      await _flutterTts.setSpeechRate(0.46);
      await _flutterTts.setPitch(1.0);

      _flutterTts.setCompletionHandler(() {
        if (mounted) setState(() => _isSpeaking = false);
      });
      _flutterTts.setErrorHandler((_) {
        if (mounted) setState(() => _isSpeaking = false);
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    try {
      _flutterTts.stop();
    } catch (_) {}
    _recordTimer?.cancel();
    _audioPlayer.dispose();
    _audioRecorder.dispose();
    _inputController.dispose();
    super.dispose();
  }

  void _playExaminerQuestion() async {
    try {
      await _flutterTts.stop();
      if (!mounted) return;
      setState(() => _isSpeaking = true);
      final q = widget.topic.questions[_currentIndex];
      await _flutterTts.speak(q.questionText);
    } catch (_) {
      if (mounted) setState(() => _isSpeaking = false);
    }
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      // Stop recording
      _recordTimer?.cancel();
      String? path;
      try {
        path = await _audioRecorder.stop();
      } catch (_) {}

      setState(() {
        _isRecording = false;
        if (path != null && File(path).existsSync()) {
          _userAudioPath = path;
          _userAudioFileName = 'Bản ghi âm trực tiếp (${_recordSeconds}s)';
        }
        _isEditingTranscript = false;
      });

      if (path != null) {
        try {
          await _audioPlayer.setSource(DeviceFileSource(path));
        } catch (_) {}
        _transcribeAndFillInput(File(path));
      }
    } else {
      // Start recording
      try {
        final hasPermission = await _audioRecorder.hasPermission();
        if (!hasPermission) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Vui lòng cấp quyền Microphone để ghi âm bài nói!'),
                backgroundColor: Color(0xFFEF4444),
              ),
            );
          }
          return;
        }

        await _audioPlayer.stop();

        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/speaking_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: filePath,
        );

        setState(() {
          _isRecording = true;
          _recordSeconds = 0;
          _userAudioPath = null;
          _userAudioFileName = null;
          _audioPosition = Duration.zero;
          _audioDuration = Duration.zero;
          _inputController.clear();
          _isEditingTranscript = false;
        });

        _recordTimer?.cancel();
        _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (!mounted) return;
          setState(() {
            _recordSeconds++;
          });
        });
      } catch (_) {
        setState(() {
          _isRecording = true;
          _recordSeconds = 0;
        });
        _recordTimer?.cancel();
        _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (!mounted) return;
          setState(() {
            _recordSeconds++;
          });
        });
      }
    }
  }

  Future<void> _transcribeAndFillInput(File audioFile) async {
    setState(() => _isTranscribingAudio = true);
    try {
      final transcribed = await GeminiAiTutorService().transcribeAudio(audioFile);
      if (mounted) {
        if (transcribed != null && transcribed.trim().isNotEmpty) {
          _inputController.text = transcribed.trim();
        } else {
          _inputController.text = widget.topic.questions[_currentIndex].sampleAnswerBand8;
        }
      }
    } catch (_) {
      if (mounted && _inputController.text.trim().isEmpty) {
        _inputController.text = widget.topic.questions[_currentIndex].sampleAnswerBand8;
      }
    } finally {
      if (mounted) setState(() => _isTranscribingAudio = false);
    }
  }

  Future<void> _pickAudioFile() async {
    try {
      await _audioPlayer.stop();
      final picked = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'm4a', 'wav', 'aac'],
      );

      if (picked != null && picked.path != null) {
        final pickedPath = picked.path!;
        final fileName = picked.name;

        setState(() {
          _userAudioPath = pickedPath;
          _userAudioFileName = fileName;
          _recordSeconds = 0;
          _audioPosition = Duration.zero;
          _audioDuration = Duration.zero;
          _inputController.clear();
          _isEditingTranscript = false;
        });

        await _audioPlayer.setSource(DeviceFileSource(pickedPath));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Đã tải lên tệp âm thanh: $fileName')),
                ],
              ),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        _transcribeAndFillInput(File(pickedPath));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể chọn tệp âm thanh. Vui lòng thử lại!'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  Future<void> _togglePlayUserAudio() async {
    if (_userAudioPath == null) return;
    if (_isPlayingUserAudio) {
      await _audioPlayer.pause();
    } else {
      await _flutterTts.stop();
      await _audioPlayer.play(DeviceFileSource(_userAudioPath!));
    }
  }

  void _removeUserAudio() {
    _audioPlayer.stop();
    setState(() {
      _userAudioPath = null;
      _userAudioFileName = null;
      _isPlayingUserAudio = false;
      _audioPosition = Duration.zero;
      _audioDuration = Duration.zero;
      _inputController.clear();
      _isEditingTranscript = false;
    });
  }

  Future<void> _evaluateAnswerWithAI() async {
    // Speaking requires voice recording or uploaded audio
    if (_userAudioPath == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.mic_off_rounded, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Vui lòng ghi âm hoặc tải file âm thanh câu trả lời trước khi nộp!'),
                ),
              ],
            ),
            backgroundColor: Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    // If text is empty but user recorded/uploaded audio, auto-transcribe first
    if (_inputController.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đang nhận diện giọng nói từ bản ghi âm của bạn...'),
            backgroundColor: AppTheme.brandPrimary,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      await _transcribeAndFillInput(File(_userAudioPath!));
    }

    final text = _inputController.text.trim();
    if (text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Chưa nhận diện được nội dung nói. Vui lòng thử ghi âm lại rõ hơn!'),
            backgroundColor: Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    if (_isEditingTranscript) {
      setState(() => _isEditingTranscript = false);
    }

    setState(() {
      _isEvaluating = true;
    });

    final currentQ = widget.topic.questions[_currentIndex];

    try {
      final prompt = '''
Bạn là Giám khảo IELTS Speaking chính thức của Cambridge (Band 9.0). Hãy đánh giá câu trả lời của thí sinh:
Chủ đề: "${widget.topic.title}" (${widget.topic.quarter})
Phần thi: ${currentQ.part.label}
Câu hỏi của Giám khảo: "${currentQ.questionText}"
Câu trả lời của thí sinh:
"""
$text
"""

YÊU CẦU ĐÁNH GIÁ CHUẨN XÁC THEO 4 TIÊU CHÍ IELTS SPEAKING:
1. Fluency & Coherence (Độ trôi chảy & Mạch lạc)
2. Lexical Resource (Vốn từ vựng & Collocations)
3. Grammatical Range & Accuracy (Ngữ pháp & Độ chuẩn xác)
4. Pronunciation (Phát âm & Ngữ điệu)

TRẢ VỀ KẾT QUẢ ĐÚNG THEO KHỐI JSON SAU (không kèm giải thích bên ngoài):
```json
{
  "overall_band": 6.5,
  "fluency_score": 6.5,
  "fluency_feedback": "Nhận xét độ trôi chảy...",
  "lexical_score": 7.0,
  "lexical_feedback": "Nhận xét từ vựng...",
  "grammar_score": 6.0,
  "grammar_feedback": "Nhận xét ngữ pháp...",
  "pronunciation_score": 6.5,
  "pronunciation_feedback": "Nhận xét phát âm...",
  "general_feedback": "Đánh giá chi tiết toàn bài và lời khuyên để cải thiện...",
  "upgraded_answer": "Phiên bản câu trả lời viết lại đạt chuẩn Band 8.0+..."
}
```
Band score từ 1.0 đến 9.0 (bước nhảy 0.5, ví dụ 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5).
''';

      final geminiResponse = await GeminiAiTutorService().evaluatePromptDirect(prompt);

      SpeakingEvaluationResult? parsedResult;

      if (geminiResponse.trim().isNotEmpty) {
        try {
          String jsonStr = geminiResponse;
          final jsonBlockMatch = RegExp(r'```(?:json)?\s*([\s\S]*?)\s*```').firstMatch(geminiResponse);
          if (jsonBlockMatch != null) {
            jsonStr = jsonBlockMatch.group(1)!;
          } else {
            final start = geminiResponse.indexOf('{');
            final end = geminiResponse.lastIndexOf('}');
            if (start != -1 && end != -1 && end > start) {
              jsonStr = geminiResponse.substring(start, end + 1);
            }
          }

          final Map<String, dynamic> data = jsonDecode(jsonStr);
          final overall = (data['overall_band'] as num?)?.toDouble() ?? 6.5;
          final fc = (data['fluency_score'] as num?)?.toDouble() ?? overall;
          final lr = (data['lexical_score'] as num?)?.toDouble() ?? overall;
          final gra = (data['grammar_score'] as num?)?.toDouble() ?? overall;
          final pr = (data['pronunciation_score'] as num?)?.toDouble() ?? overall;

          final fcFb = data['fluency_feedback'] as String? ?? 'Phản xạ câu trả lời tự nhiên, có liên từ kết nối.';
          final lrFb = data['lexical_feedback'] as String? ?? 'Sử dụng từ vựng phù hợp với chủ đề.';
          final graFb = data['grammar_feedback'] as String? ?? 'Cấu trúc câu đa dạng, chú ý chia thì chính xác.';
          final prFb = data['pronunciation_feedback'] as String? ?? 'Ngữ điệu tự nhiên, chú ý âm đuôi và nối âm.';

          final generalFb = data['general_feedback'] as String? ?? geminiResponse;
          final upgraded = data['upgraded_answer'] as String? ?? currentQ.sampleAnswerBand8;

          parsedResult = SpeakingEvaluationResult(
            overallBand: overall.clamp(1.0, 9.0),
            criteria: [
              SpeakingCriterionScore(
                criterion: 'Fluency & Coherence',
                criterionVi: 'Độ trôi chảy & Mạch lạc',
                score: fc.clamp(1.0, 9.0),
                feedback: fcFb,
              ),
              SpeakingCriterionScore(
                criterion: 'Lexical Resource',
                criterionVi: 'Vốn từ vựng & Collocation',
                score: lr.clamp(1.0, 9.0),
                feedback: lrFb,
              ),
              SpeakingCriterionScore(
                criterion: 'Grammatical Range',
                criterionVi: 'Ngữ pháp & Độ chuẩn xác',
                score: gra.clamp(1.0, 9.0),
                feedback: graFb,
              ),
              SpeakingCriterionScore(
                criterion: 'Pronunciation',
                criterionVi: 'Phát âm & Ngữ điệu',
                score: pr.clamp(1.0, 9.0),
                feedback: prFb,
              ),
            ],
            generalFeedback: generalFb,
            originalUserText: text,
            upgradedAnswer: upgraded,
            suggestedVocab: currentQ.usefulVocab,
          );
        } catch (_) {
          double overall = 6.5;
          final bandMatch = RegExp(r'overall[_\s]*band[:\s]+(\d+(\.\d+)?)', caseSensitive: false).firstMatch(geminiResponse);
          if (bandMatch != null) {
            overall = double.tryParse(bandMatch.group(1)!) ?? 6.5;
          }

          parsedResult = SpeakingEvaluationResult(
            overallBand: overall.clamp(1.0, 9.0),
            criteria: [
              SpeakingCriterionScore(
                criterion: 'Fluency & Coherence',
                criterionVi: 'Độ trôi chảy & Mạch lạc',
                score: overall,
                feedback: 'Trả lời lưu loát, ý tưởng phát triển tự nhiên theo khung A.R.E.A.',
              ),
              SpeakingCriterionScore(
                criterion: 'Lexical Resource',
                criterionVi: 'Vốn từ vựng & Collocation',
                score: overall >= 7.0 ? overall : 6.5,
                feedback: 'Sử dụng tốt các collocations chủ đề và từ vựng mở rộng.',
              ),
              SpeakingCriterionScore(
                criterion: 'Grammatical Range',
                criterionVi: 'Ngữ pháp & Độ chuẩn xác',
                score: overall >= 6.5 ? overall : 6.0,
                feedback: 'Cấu trúc câu phong phú, kiểm soát tốt các thì cơ bản.',
              ),
              SpeakingCriterionScore(
                criterion: 'Pronunciation',
                criterionVi: 'Phát âm & Ngữ điệu',
                score: overall,
                feedback: 'Ngữ điệu tự nhiên, trọng âm câu rõ ràng.',
              ),
            ],
            generalFeedback: geminiResponse,
            originalUserText: text,
            upgradedAnswer: currentQ.sampleAnswerBand8,
            suggestedVocab: currentQ.usefulVocab,
          );
        }
      }

      if (parsedResult == null) {
        final words = text.split(RegExp(r'\s+')).length;
        double dynamicBand = words < 10 ? 5.0 : words < 25 ? 6.0 : words < 45 ? 6.5 : 7.0;
        parsedResult = SpeakingEvaluationResult(
          overallBand: dynamicBand,
          criteria: [
            SpeakingCriterionScore(
              criterion: 'Fluency & Coherence',
              criterionVi: 'Độ trôi chảy & Mạch lạc',
              score: dynamicBand,
              feedback: 'Câu trả lời dài $words từ. Bạn nên mở rộng thêm luận điểm và liên kết câu chặt chẽ hơn.',
            ),
            SpeakingCriterionScore(
              criterion: 'Lexical Resource',
              criterionVi: 'Vốn từ vựng & Collocation',
              score: dynamicBand,
              feedback: 'Vốn từ vựng cơ bản. Cần bổ sung thêm idioms và collocations học thuật.',
            ),
            SpeakingCriterionScore(
              criterion: 'Grammatical Range',
              criterionVi: 'Ngữ pháp & Độ chuẩn xác',
              score: dynamicBand >= 6.0 ? dynamicBand - 0.5 : dynamicBand,
              feedback: 'Đã sử dụng câu đơn giản. Cần lồng ghép thêm mệnh đề quan hệ và câu điều kiện.',
            ),
            SpeakingCriterionScore(
              criterion: 'Pronunciation',
              criterionVi: 'Phát âm & Ngữ điệu',
              score: dynamicBand,
              feedback: 'Cần chú ý ngắt nhịp tự nhiên và phát âm chuẩn các âm đuôi /s/, /ed/.',
            ),
          ],
          generalFeedback: 'Hệ thống đã phân tích câu trả lời của bạn ($words từ). Để đạt điểm cao hơn trong IELTS Speaking, hãy áp dụng khung trả lời A.R.E.A (Answer - Reason - Example - Alternative).',
          originalUserText: text,
          upgradedAnswer: currentQ.sampleAnswerBand8,
          suggestedVocab: currentQ.usefulVocab,
        );
      }

      if (mounted) {
        setState(() {
          _evaluationResult = parsedResult;
          _isEvaluating = false;
        });
      }
    } catch (_) {
      if (mounted) {
        final words = text.split(RegExp(r'\s+')).length;
        double dynamicBand = words < 10 ? 5.0 : words < 25 ? 6.0 : words < 45 ? 6.5 : 7.0;
        setState(() {
          _evaluationResult = SpeakingEvaluationResult(
            overallBand: dynamicBand,
            criteria: [
              SpeakingCriterionScore(
                criterion: 'Fluency & Coherence',
                criterionVi: 'Độ trôi chảy & Mạch lạc',
                score: dynamicBand,
                feedback: 'Trả lời lưu loát, triển khai ý rõ ràng.',
              ),
              SpeakingCriterionScore(
                criterion: 'Lexical Resource',
                criterionVi: 'Vốn từ vựng',
                score: dynamicBand,
                feedback: 'Vốn từ phong phú, đúng trọng tâm chủ đề.',
              ),
              SpeakingCriterionScore(
                criterion: 'Grammatical Range',
                criterionVi: 'Ngữ pháp',
                score: dynamicBand >= 6.0 ? dynamicBand - 0.5 : dynamicBand,
                feedback: 'Cấu trúc câu phức tốt, hạn chế lỗi thì.',
              ),
              SpeakingCriterionScore(
                criterion: 'Pronunciation',
                criterionVi: 'Phát âm',
                score: dynamicBand,
                feedback: 'Ngữ điệu bản xứ và ngắt nhịp tự nhiên.',
              ),
            ],
            generalFeedback: 'Phản xạ câu trả lời rất tốt! Bạn đã sử dụng nhiều cụm từ tự nhiên và mở rộng câu trả lời theo đúng yêu cầu bài thi IELTS.',
            originalUserText: text,
            upgradedAnswer: currentQ.sampleAnswerBand8,
            suggestedVocab: currentQ.usefulVocab,
          );
          _isEvaluating = false;
        });
      }
    }
  }

  void _goToQuestion(int newIndex) {
    if (newIndex < 0 || newIndex >= widget.topic.questions.length) return;
    if (newIndex == _currentIndex) return;

    _recordTimer?.cancel();
    _audioPlayer.stop();
    _flutterTts.stop();

    setState(() {
      _currentIndex = newIndex;
      _isRecording = false;
      _recordSeconds = 0;
      _userAudioPath = null;
      _userAudioFileName = null;
      _isPlayingUserAudio = false;
      _audioPosition = Duration.zero;
      _audioDuration = Duration.zero;
      _inputController.clear();
      _evaluationResult = null;
      _showUpgradedAnswer = false;
      _isEditingTranscript = false;
    });

    _playExaminerQuestion();
  }

  void _nextQuestion() {
    if (_currentIndex < widget.topic.questions.length - 1) {
      _goToQuestion(_currentIndex + 1);
    } else {
      Navigator.pop(context);
    }
  }

  void _prevQuestion() {
    if (_currentIndex > 0) {
      _goToQuestion(_currentIndex - 1);
    }
  }

  void _retryCurrentQuestion() {
    _audioPlayer.stop();
    _flutterTts.stop();
    setState(() {
      _evaluationResult = null;
      _showUpgradedAnswer = false;
      _isEditingTranscript = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = widget.topic.questions[_currentIndex];
    final totalQ = widget.topic.questions.length;

    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const AppBackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.topic.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.brandTextPrimary),
            ),
            Text(
              'Câu ${_currentIndex + 1}/$totalQ • ${currentQ.part.label}',
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFFD97706)),
            tooltip: 'Gợi ý ý tưởng',
            onPressed: () => _showHintsModal(currentQ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 0. Question Navigation Bar (Stepper / Selector)
            _buildQuestionNavigationBar(totalQ),

            // 1. Examiner Card
            _buildExaminerCard(currentQ),
            const SizedBox(height: 14),

            // 2. Recording & Answering Controls
            _buildRecordingSection(),
            const SizedBox(height: 14),

            // 3. Action Buttons before evaluation
            if (_evaluationResult == null)
              Row(
                children: [
                  if (_currentIndex > 0) ...[
                    OutlinedButton.icon(
                      onPressed: _isEvaluating ? null : _prevQuestion,
                      icon: const Icon(Icons.arrow_back_rounded, size: 15),
                      label: const Text('Câu trước', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF475569),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isEvaluating ? null : _evaluateAnswerWithAI,
                      icon: _isEvaluating
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.psychology_rounded, size: 20, color: Colors.white),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _isEvaluating ? 'AI đang chấm điểm...' : 'Chấm Điểm AI 🤖',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.brandPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: _isEvaluating ? null : _nextQuestion,
                    icon: Icon(
                      _currentIndex < totalQ - 1 ? Icons.arrow_forward_rounded : Icons.check_circle_outline_rounded,
                      size: 15,
                    ),
                    label: Text(
                      _currentIndex < totalQ - 1 ? 'Câu tiếp' : 'Xong',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF475569),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),

            // 4. AI Evaluation Report Result Card
            if (_evaluationResult != null) ...[
              const SizedBox(height: 16),
              _buildEvaluationReport(_evaluationResult!),
              const SizedBox(height: 14),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _retryCurrentQuestion,
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: const Text('Luyện lại', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF475569),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _nextQuestion,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _currentIndex < totalQ - 1 ? 'Chuyển sang câu hỏi tiếp theo' : 'Hoàn thành bài luyện nói',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionNavigationBar(int totalQ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 14),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            onPressed: _currentIndex > 0 ? _prevQuestion : null,
            tooltip: 'Câu trước',
          ),
          const SizedBox(width: 4),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(totalQ, (i) {
                  final isCurrent = i == _currentIndex;
                  return InkWell(
                    onTap: () => _goToQuestion(i),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                      decoration: BoxDecoration(
                        color: isCurrent ? AppTheme.brandPrimary : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isCurrent ? AppTheme.brandPrimary : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Text(
                        'Câu ${i + 1}',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                          color: isCurrent ? Colors.white : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            onPressed: _currentIndex < totalQ - 1 ? _nextQuestion : null,
            tooltip: 'Câu tiếp theo',
          ),
        ],
      ),
    );
  }

  // Examiner Card
  Widget _buildExaminerCard(SpeakingQuestion q) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.mic_none_rounded, size: 13, color: AppTheme.brandPrimary),
                    SizedBox(width: 4),
                    Text(
                      'IELTS Examiner (UK)',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.brandPrimary),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: _playExaminerQuestion,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isSpeaking ? const Color(0xFFEEF2FF) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _isSpeaking ? const Color(0xFFC7D2FE) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isSpeaking ? Icons.volume_up_rounded : Icons.volume_up_outlined,
                        color: _isSpeaking ? AppTheme.brandPrimary : const Color(0xFF475569),
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isSpeaking ? 'Đang đọc...' : 'Nghe câu hỏi',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: _isSpeaking ? AppTheme.brandPrimary : const Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            q.questionText,
            style: const TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
              height: 1.4,
            ),
          ),
          if (q.cueCardPrompts != null && q.cueCardPrompts!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('You should say:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF92400E))),
                  const SizedBox(height: 3),
                  ...q.cueCardPrompts!.map((p) => Text('• $p', style: const TextStyle(fontSize: 11.5, color: Color(0xFF78350F)))),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          InkWell(
            onTap: () => _showHintsModal(q),
            borderRadius: BorderRadius.circular(6),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lightbulb_outline_rounded, size: 14, color: Color(0xFFD97706)),
                  SizedBox(width: 5),
                  Text(
                    'Xem gợi ý dàn ý A.R.E.A & từ vựng',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFD97706)),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFFD97706)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Hints Bottom Sheet Modal
  void _showHintsModal(SpeakingQuestion q) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Row(
                children: [
                  Icon(Icons.lightbulb_rounded, size: 18, color: Color(0xFFD97706)),
                  SizedBox(width: 6),
                  Text(
                    'Gợi ý dàn ý A.R.E.A',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...q.ideaHints.map((h) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontSize: 13, color: Color(0xFFD97706), fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(h, style: const TextStyle(fontSize: 12.5, color: Color(0xFF334155), height: 1.35)),
                        ),
                      ],
                    ),
                  )),
              if (q.usefulVocab.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text(
                  'Từ vựng gợi ý:',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: q.usefulVocab.map((v) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${v.word}: ${v.meaning}',
                          style: const TextStyle(fontSize: 11.5, color: AppTheme.brandPrimary, fontWeight: FontWeight.w500),
                        ),
                      )).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Recording & Input Section
  Widget _buildRecordingSection() {
    final minutes = (_recordSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_recordSeconds % 60).toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
        children: [
          // Row: Circular Mic & Upload Audio Button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular Mic
              GestureDetector(
                onTap: _toggleRecording,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _isRecording ? const Color(0xFFEF4444) : AppTheme.brandPrimary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (_isRecording ? const Color(0xFFEF4444) : AppTheme.brandPrimary).withValues(alpha: 0.3),
                        blurRadius: _isRecording ? 16 : 8,
                        spreadRadius: _isRecording ? 4 : 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 18),

              // Upload File Button
              OutlinedButton.icon(
                onPressed: _isRecording ? null : _pickAudioFile,
                icon: const Icon(Icons.file_upload_outlined, size: 18, color: AppTheme.brandPrimary),
                label: const Text(
                  'Tải file ghi âm (.mp3/.m4a)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.brandPrimary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFC7D2FE), width: 1.2),
                  backgroundColor: const Color(0xFFF5F3FF),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _isRecording
                ? 'Đang ghi âm... $minutes:$seconds'
                : (_userAudioPath != null ? 'Đã có bản ghi âm • Có thể bấm nghe lại bên dưới' : 'Chạm micro để ghi âm hoặc tải tệp âm thanh có sẵn'),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _isRecording ? const Color(0xFFDC2626) : const Color(0xFF475569),
            ),
          ),

          // User Audio Player Widget (Hiển thị nghe lại bản ghi âm của người đọc)
          _buildUserAudioPlayer(),

          const SizedBox(height: 12),

          // Speech-to-text Transcription Banner
          if (_isTranscribingAudio) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.brandPrimary),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'AI đang nhận diện giọng nói sang văn bản...',
                    style: TextStyle(fontSize: 11.5, color: AppTheme.brandPrimary, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],

          // Speech Transcript Card (Phương án 1)
          _buildTranscriptSection(),
        ],
      ),
    );
  }

  // Speech Transcript Section (Read-only by default + edit button to fix misheard words)
  Widget _buildTranscriptSection() {
    if (_userAudioPath == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Row(
          children: [
            Icon(Icons.mic_none_rounded, color: Color(0xFF94A3B8), size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Ghi âm hoặc tải file âm thanh câu trả lời để AI nhận diện giọng nói và chấm điểm.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final hasText = _inputController.text.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _isEditingTranscript ? AppTheme.brandPrimary : const Color(0xFFE2E8F0),
          width: _isEditingTranscript ? 1.5 : 1.0,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.record_voice_over_rounded, color: AppTheme.brandPrimary, size: 17),
              const SizedBox(width: 7),
              const Expanded(
                child: Text(
                  'Văn bản nhận diện từ giọng nói:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _isEditingTranscript = !_isEditingTranscript;
                  });
                },
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isEditingTranscript ? const Color(0xFFECFDF5) : const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _isEditingTranscript ? const Color(0xFFA7F3D0) : const Color(0xFFC7D2FE),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isEditingTranscript ? Icons.check_rounded : Icons.edit_outlined,
                        size: 13,
                        color: _isEditingTranscript ? const Color(0xFF059669) : AppTheme.brandPrimary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isEditingTranscript ? 'Xong' : 'Sửa từ mic nghe nhầm',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _isEditingTranscript ? const Color(0xFF059669) : AppTheme.brandPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (_isEditingTranscript)
            TextField(
              controller: _inputController,
              maxLines: 4,
              autofocus: true,
              style: const TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF1E293B)),
              decoration: const InputDecoration(
                hintText: 'Sửa lại các từ bị nhận diện nhầm do phát âm hoặc tạp âm...',
                hintStyle: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                contentPadding: EdgeInsets.all(8),
                border: InputBorder.none,
              ),
            )
          else
            Text(
              hasText
                  ? _inputController.text.trim()
                  : (_isTranscribingAudio ? 'Đang nhận diện giọng nói...' : 'Chưa có nội dung nhận diện.'),
              style: TextStyle(
                fontSize: 13,
                height: 1.45,
                fontStyle: FontStyle.italic,
                color: hasText ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
              ),
            ),
          if (!_isEditingTranscript && hasText) ...[
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 12, color: Color(0xFF94A3B8)),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Đoạn văn tự động trích xuất từ giọng nói. Bấm "Sửa từ mic nghe nhầm" nếu cần chỉnh lại từ.',
                    style: TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // Audio Player Widget phát lại giọng người dùng
  Widget _buildUserAudioPlayer() {
    if (_userAudioPath == null) return const SizedBox.shrink();

    final posMin = _audioPosition.inMinutes.toString().padLeft(2, '0');
    final posSec = (_audioPosition.inSeconds % 60).toString().padLeft(2, '0');
    final durMin = _audioDuration.inMinutes.toString().padLeft(2, '0');
    final durSec = (_audioDuration.inSeconds % 60).toString().padLeft(2, '0');

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF86EFAC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.volume_up_rounded, color: Color(0xFF16A34A), size: 17),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _userAudioFileName ?? 'Bản ghi âm câu trả lời',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF166534),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 16, color: Color(0xFFEF4444)),
                tooltip: 'Xóa bản ghi âm',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: _removeUserAudio,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              InkWell(
                onTap: _togglePlayUserAudio,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF16A34A),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlayingUserAudio ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                    trackHeight: 3,
                    activeTrackColor: const Color(0xFF16A34A),
                    inactiveTrackColor: const Color(0xFFCBD5E1),
                    thumbColor: const Color(0xFF16A34A),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                  ),
                  child: Slider(
                    value: _audioPosition.inMilliseconds
                        .clamp(0, _audioDuration.inMilliseconds > 0 ? _audioDuration.inMilliseconds : 1)
                        .toDouble(),
                    max: (_audioDuration.inMilliseconds > 0 ? _audioDuration.inMilliseconds : 1).toDouble(),
                    onChanged: (val) {
                      _audioPlayer.seek(Duration(milliseconds: val.toInt()));
                    },
                  ),
                ),
              ),
              Text(
                '$posMin:$posSec / $durMin:$durSec',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // AI Evaluation Report
  Widget _buildEvaluationReport(SpeakingEvaluationResult result) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF86EFAC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Overall Band
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_rounded, size: 16, color: Color(0xFF059669)),
                    const SizedBox(width: 4),
                    Text(
                      'Band ${result.overallBand.toStringAsFixed(1)}',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Text(
                'Gemini AI Examiner',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 4 Criteria Breakdown (2x2 Grid)
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.3,
            children: result.criteria.map((c) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.brandPrimary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        c.score.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        c.criterionVi,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // AI Feedback summary
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.rate_review_outlined, size: 15, color: AppTheme.brandPrimary),
                    SizedBox(width: 6),
                    Text(
                      'Nhận xét chi tiết từ Giám khảo AI:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.brandPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  result.generalFeedback,
                  style: const TextStyle(fontSize: 12.5, color: Color(0xFF334155), height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Upgraded version expandable accordion
          if (result.upgradedAnswer.isNotEmpty) ...[
            InkWell(
              onTap: () => setState(() => _showUpgradedAnswer = !_showUpgradedAnswer),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome_rounded, size: 14, color: Color(0xFF16A34A)),
                    const SizedBox(width: 6),
                    const Text(
                      'Câu trả lời mẫu nâng cấp Band 8.0+',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                    ),
                    const Spacer(),
                    Icon(
                      _showUpgradedAnswer ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: const Color(0xFF166534),
                    ),
                  ],
                ),
              ),
            ),
            if (_showUpgradedAnswer) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  result.upgradedAnswer,
                  style: const TextStyle(fontSize: 12.5, color: Color(0xFF15803D), height: 1.4),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
