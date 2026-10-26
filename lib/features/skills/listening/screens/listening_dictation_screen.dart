import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app/theme.dart';
import '../models/dictation_model.dart';
import '../data/listening_mock_data.dart';
import '../data/dictation_archive_repository.dart';
import '../../../../shared/widgets/app_back_button.dart';

class ListeningDictationScreen extends StatefulWidget {
  final DictationExercise? exercise;

  const ListeningDictationScreen({
    super.key,
    this.exercise,
  });

  @override
  State<ListeningDictationScreen> createState() => _ListeningDictationScreenState();
}

class _ListeningDictationScreenState extends State<ListeningDictationScreen> {
  late DictationExercise _exercise;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _flutterTts = FlutterTts();
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  StreamSubscription? _playerStateSub;

  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _showHint = false;
  bool _isChecked = false;
  bool _isRevealed = false;
  double _lastAccuracy = 0.0;
  bool _isFinished = false;

  String _selectedAccent = 'en-GB'; // 'en-GB' (UK) or 'en-US' (US)

  // Track progress and answers across sentences
  final Map<int, String> _userAnswers = {};
  final Map<int, bool> _completedMap = {};

  @override
  void initState() {
    super.initState();
    _exercise = widget.exercise ?? ListeningMockData.dictationExercises.first;
    _initAudioPlayer();
    _initTts();

    // Auto-play initial sentence after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _playCurrentSentence(isSlow: false);
      }
    });
  }

  void _initAudioPlayer() {
    _playerStateSub = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      if (state == PlayerState.completed || state == PlayerState.stopped) {
        setState(() => _isPlaying = false);
      } else if (state == PlayerState.playing) {
        setState(() => _isPlaying = true);
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

      await _flutterTts.setLanguage(_selectedAccent);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.46);

      _flutterTts.setCompletionHandler(() {
        if (mounted) setState(() => _isPlaying = false);
      });
      _flutterTts.setErrorHandler((_) {
        if (mounted) setState(() => _isPlaying = false);
      });
    } catch (_) {
      // Graceful fallback if TTS fails on specific hardware
    }
  }

  @override
  void dispose() {
    _playerStateSub?.cancel();
    _audioPlayer.dispose();
    try {
      _flutterTts.stop();
    } catch (_) {}
    _inputController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  void _unfocus() {
    if (_inputFocusNode.hasFocus) {
      _inputFocusNode.unfocus();
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> _stopAllAudio() async {
    try {
      await _audioPlayer.stop();
    } catch (_) {}
    try {
      await _flutterTts.stop();
    } catch (_) {}
    if (mounted) setState(() => _isPlaying = false);
  }

  void _playCurrentSentence({required bool isSlow}) async {
    if (_isFinished) return;
    final sentence = _exercise.sentences[_currentIndex];
    final speed = isSlow ? 0.75 : 1.0;

    await _stopAllAudio();

    if (sentence.audioUrl != null && sentence.audioUrl!.trim().isNotEmpty) {
      try {
        await _audioPlayer.setPlaybackRate(speed);
        await _audioPlayer.play(UrlSource(sentence.audioUrl!.trim()));
        if (mounted) setState(() => _isPlaying = true);
        return;
      } catch (_) {
        // Fallback to TTS if network audio playback fails
      }
    }

    _speakTts(sentence.targetText, isSlow: isSlow);
  }

  void _playSpecificSentence(DictationSentence sentence) async {
    await _stopAllAudio();
    if (sentence.audioUrl != null && sentence.audioUrl!.trim().isNotEmpty) {
      try {
        await _audioPlayer.setPlaybackRate(1.0);
        await _audioPlayer.play(UrlSource(sentence.audioUrl!.trim()));
        if (mounted) setState(() => _isPlaying = true);
        return;
      } catch (_) {
        // Fallback to TTS if network audio fails
      }
    }
    _speakTts(sentence.targetText, isSlow: false);
  }

  void _speakTts(String text, {required bool isSlow}) async {
    try {
      await _flutterTts.stop();
      if (!mounted) return;
      setState(() => _isPlaying = true);
      await _flutterTts.setLanguage(_selectedAccent);
      await _flutterTts.setSpeechRate(isSlow ? 0.30 : 0.46);
      await _flutterTts.speak(text);
    } catch (_) {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  void _checkAnswer() {
    final current = _exercise.sentences[_currentIndex];
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    final accuracy = current.calculateAccuracy(text);
    final isAccurate = current.isAccurate(text);

    _userAnswers[_currentIndex] = text;
    if (isAccurate || accuracy >= 0.7) {
      _completedMap[_currentIndex] = true;
    }

    setState(() {
      _isChecked = true;
      _isRevealed = false;
      _lastAccuracy = accuracy;
    });
    _unfocus();
  }

  void _revealAnswer() {
    final current = _exercise.sentences[_currentIndex];
    setState(() {
      _isChecked = true;
      _isRevealed = true;
      _showHint = true;
      _lastAccuracy = current.calculateAccuracy(_inputController.text);
    });
    _unfocus();
  }

  void _copyAnswerToInput() {
    final current = _exercise.sentences[_currentIndex];
    setState(() {
      _inputController.text = current.targetText;
      _userAnswers[_currentIndex] = current.targetText;
      _completedMap[_currentIndex] = true;
      _lastAccuracy = 1.0;
      _isRevealed = false;
      _isChecked = true;
    });
    _unfocus();
  }

  void _resetCurrentSentence() {
    setState(() {
      _isChecked = false;
      _isRevealed = false;
      _showHint = false;
      _lastAccuracy = 0.0;
      _inputController.clear();
      _userAnswers[_currentIndex] = '';
    });
    _playCurrentSentence(isSlow: false);
    _unfocus();
  }

  void _prevSentence() {
    if (_currentIndex > 0) {
      _saveCurrentAnswer();
      setState(() {
        _currentIndex--;
        _loadSentenceState();
      });
      _playCurrentSentence(isSlow: false);
      _unfocus();
    }
  }

  void _nextSentence() {
    if (_currentIndex < _exercise.sentences.length - 1) {
      _saveCurrentAnswer();
      setState(() {
        _currentIndex++;
        _loadSentenceState();
      });
      _playCurrentSentence(isSlow: false);
      _unfocus();
    } else {
      _showFinishConfirmation();
    }
  }

  void _jumpToSentence(int index) {
    if (index >= 0 && index < _exercise.sentences.length && index != _currentIndex) {
      _saveCurrentAnswer();
      setState(() {
        _currentIndex = index;
        _loadSentenceState();
      });
      _playCurrentSentence(isSlow: false);
      _unfocus();
    }
  }

  void _saveCurrentAnswer() {
    _userAnswers[_currentIndex] = _inputController.text.trim();
  }

  void _loadSentenceState() {
    final existingAnswer = _userAnswers[_currentIndex] ?? '';
    _inputController.text = existingAnswer;
    _isChecked = _completedMap[_currentIndex] == true;
    _isRevealed = false;
    _showHint = false;
    if (existingAnswer.isNotEmpty) {
      _lastAccuracy = _exercise.sentences[_currentIndex].calculateAccuracy(existingAnswer);
    } else {
      _lastAccuracy = 0.0;
    }
  }

  DictationExercise? _getNextExercise() {
    final all = DictationArchiveRepository.allExercises;
    if (all.isEmpty) return null;
    final currentIdx = all.indexWhere((e) => e.id == _exercise.id);
    if (currentIdx != -1 && currentIdx + 1 < all.length) {
      return all[currentIdx + 1];
    }
    return null;
  }

  void _practiceIncorrectSentences() {
    final incorrect = <DictationSentence>[];
    for (int i = 0; i < _exercise.sentences.length; i++) {
      final s = _exercise.sentences[i];
      final ans = _userAnswers[i] ?? '';
      if (!s.isAccurate(ans)) {
        incorrect.add(s);
      }
    }
    if (incorrect.isEmpty) return;
    final reviewEx = DictationExercise(
      id: '${_exercise.id}_review',
      title: '${_exercise.title} (Luyện câu sai)',
      bandLevel: _exercise.bandLevel,
      sourceTopic: _exercise.sourceTopic,
      category: _exercise.category,
      description: 'Luyện lại ${incorrect.length} câu chưa đạt 100%',
      durationMinutes: ((incorrect.length / _exercise.sentences.length) * _exercise.durationMinutes).ceil().clamp(1, 15),
      sentences: incorrect,
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ListeningDictationScreen(exercise: reviewEx),
      ),
    );
  }

  void _showFinishConfirmation() {
    _stopAllAudio();
    final completedCount = _completedMap.length;
    final total = _exercise.sentences.length;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Kết thúc bài học?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Bạn đã làm được $completedCount/$total câu. Bạn có muốn xem tổng kết kết quả ngay bây giờ?',
          style: const TextStyle(fontSize: 13.5, color: Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Luyện tiếp', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _isFinished = true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.brandPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Xem kết quả'),
          ),
        ],
      ),
    );
  }

  void _resetExercise() {
    setState(() {
      _currentIndex = 0;
      _isChecked = false;
      _isRevealed = false;
      _showHint = false;
      _lastAccuracy = 0.0;
      _isFinished = false;
      _inputController.clear();
      _userAnswers.clear();
      _completedMap.clear();
    });
    _playCurrentSentence(isSlow: false);
    _unfocus();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFinished) {
      return _buildFinishedScreen();
    }

    final currentSentence = _exercise.sentences[_currentIndex];
    final totalSentences = _exercise.sentences.length;
    final completedCount = _completedMap.length;

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
              _exercise.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            Text(
              'Câu ${_currentIndex + 1}/$totalSentences • ${_exercise.bandLevel}',
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: TextButton.icon(
              onPressed: _showFinishConfirmation,
              icon: const Icon(Icons.check_circle_outline_rounded, size: 16, color: Color(0xFF4F46E5)),
              label: const Text(
                'Kết thúc',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5)),
              ),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFEEF2FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _unfocus,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Horizontal Sentence Quick Jump Bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(totalSentences, (idx) {
                  final isCurrent = idx == _currentIndex;
                  final isDone = _completedMap[idx] == true;

                  Color bg = const Color(0xFFF1F5F9);
                  Color text = const Color(0xFF64748B);
                  Border? border;

                  if (isCurrent) {
                    bg = AppTheme.brandPrimary;
                    text = Colors.white;
                  } else if (isDone) {
                    bg = const Color(0xFFDCFCE7);
                    text = const Color(0xFF15803D);
                    border = Border.all(color: const Color(0xFF86EFAC));
                  }

                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: InkWell(
                      onTap: () => _jumpToSentence(idx),
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(6),
                          border: border,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isDone && !isCurrent)
                              const Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: Icon(Icons.check, size: 12, color: Color(0xFF16A34A)),
                              ),
                            Text(
                              'Câu ${idx + 1}',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                                color: text,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 10),

            // Progress Bar
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (_currentIndex + 1) / totalSentences,
                      minHeight: 4,
                      backgroundColor: const Color(0xFFE2E8F0),
                      valueColor: const AlwaysStoppedAnimation(AppTheme.brandPrimary),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Đã làm: $completedCount/$totalSentences',
                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 2. Audio Card with Controls (Safe responsive layout)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
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
                children: [
                  // Play button
                  GestureDetector(
                    onTap: () => _playCurrentSentence(isSlow: false),
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4F46E5), Color(0xFF3B82F6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(29),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4F46E5).withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isPlaying ? Icons.volume_up_rounded : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Chạm nút để nghe câu phát âm',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 12),

                  // Helper Controls Row (Flexible to prevent any overflow)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _playCurrentSentence(isSlow: false),
                          icon: const Icon(Icons.replay_rounded, size: 14, color: AppTheme.brandPrimary),
                          label: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('Nghe 1.0x', style: TextStyle(fontSize: 11)),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.brandPrimary,
                            side: const BorderSide(color: Color(0xFFC7D2FE)),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _playCurrentSentence(isSlow: true),
                          icon: const Icon(Icons.slow_motion_video_rounded, size: 14, color: Color(0xFF6366F1)),
                          label: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('Chậm 0.75x', style: TextStyle(fontSize: 11)),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF4F46E5),
                            side: const BorderSide(color: Color(0xFFC7D2FE)),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => setState(() => _showHint = !_showHint),
                          icon: Icon(
                            _showHint ? Icons.visibility_off_outlined : Icons.lightbulb_outline_rounded,
                            size: 14,
                            color: const Color(0xFFD97706),
                          ),
                          label: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(_showHint ? 'Ẩn gợi ý' : 'Gợi ý', style: const TextStyle(fontSize: 11)),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFD97706),
                            side: const BorderSide(color: Color(0xFFFDE68A)),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Hint box
                  if (_showHint) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        currentSentence.hint,
                        style: const TextStyle(
                          fontSize: 12,
                          letterSpacing: 1.1,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 10),

            // 3. Sentence Navigation (Câu trước ‹ & Đáp án 👁 & Câu sau ›)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _currentIndex > 0 ? _prevSentence : null,
                    icon: const Icon(Icons.arrow_back_rounded, size: 16),
                    label: const FittedBox(fit: BoxFit.scaleDown, child: Text('Trước')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF475569),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _revealAnswer,
                    icon: const Icon(Icons.visibility_rounded, size: 15, color: Color(0xFF0284C7)),
                    label: const FittedBox(fit: BoxFit.scaleDown, child: Text('Đáp án', style: TextStyle(color: Color(0xFF0284C7)))),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFBAE6FD)),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _currentIndex < totalSentences - 1 ? _nextSentence : _showFinishConfirmation,
                    icon: Icon(
                      _currentIndex < totalSentences - 1 ? Icons.arrow_forward_rounded : Icons.check_circle_outline_rounded,
                      size: 16,
                    ),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(_currentIndex < totalSentences - 1 ? 'Sau' : 'Nộp bài'),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.brandPrimary,
                      side: const BorderSide(color: Color(0xFFC7D2FE)),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 4. Word count indicator & Input TextField
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.spellcheck_rounded, size: 13, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text(
                        'Câu gồm ${currentSentence.targetText.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length} từ',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                      ),
                    ],
                  ),
                ),
                if (currentSentence.translationVi.isNotEmpty && (_showHint || _isChecked || _isRevealed)) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      currentSentence.translationVi,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11.5, fontStyle: FontStyle.italic, color: Color(0xFF64748B)),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _isChecked
                      ? (_lastAccuracy >= 0.70 ? const Color(0xFF10B981) : const Color(0xFFF59E0B))
                      : const Color(0xFFCBD5E1),
                  width: 1.5,
                ),
              ),
              child: TextField(
                controller: _inputController,
                focusNode: _inputFocusNode,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  if (_inputController.text.trim().isNotEmpty) {
                    _checkAnswer();
                  }
                },
                maxLines: 3,
                onChanged: (val) {
                  // Rebuild to update button enable state and clear icon
                  setState(() {
                    if (_isChecked && !_isRevealed) {
                      _isChecked = false;
                    }
                  });
                },
                style: const TextStyle(fontSize: 14, height: 1.4),
                decoration: InputDecoration(
                  hintText: 'Gõ lại chính xác câu bạn nghe được...',
                  hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                  contentPadding: const EdgeInsets.all(12),
                  border: InputBorder.none,
                  suffixIcon: _inputController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18, color: Color(0xFF94A3B8)),
                          onPressed: () {
                            _inputController.clear();
                            setState(() {
                              _isChecked = false;
                              _isRevealed = false;
                            });
                          },
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 5. Action Button: Kiểm tra / Làm lại
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: _inputController.text.trim().isEmpty ? null : _checkAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.brandPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text('Kiểm tra câu trả lời', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                  ),
                ),
                if (_isChecked || _isRevealed) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: OutlinedButton.icon(
                      onPressed: _resetCurrentSentence,
                      icon: const Icon(Icons.replay_rounded, size: 15),
                      label: const Text('Làm lại', style: TextStyle(fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF475569),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ],
            ),

            // 6. Reveal Mode Banner
            if (_isRevealed) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
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
                        const Icon(Icons.lightbulb_rounded, size: 18, color: Color(0xFF16A34A)),
                        const SizedBox(width: 6),
                        const Text(
                          'Đáp án tham khảo:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF15803D)),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: _copyAnswerToInput,
                          child: const Row(
                            children: [
                              Icon(Icons.copy_rounded, size: 13, color: Color(0xFF16A34A)),
                              SizedBox(width: 3),
                              Text('Điền vào ô', style: TextStyle(fontSize: 11, color: Color(0xFF16A34A), fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      currentSentence.targetText,
                      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      currentSentence.translationVi,
                      style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ],

            // 7. Feedback & Word Diff Box (When checked)
            if (_isChecked && !_isRevealed) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _lastAccuracy >= 0.70 ? const Color(0xFFECFDF5) : const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _lastAccuracy >= 0.70 ? const Color(0xFFA7F3D0) : const Color(0xFFFDE68A),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _lastAccuracy >= 0.70 ? Icons.check_circle_rounded : Icons.info_rounded,
                          size: 18,
                          color: _lastAccuracy >= 0.70 ? const Color(0xFF059669) : const Color(0xFFD97706),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Độ chính xác: ${(_lastAccuracy * 100).toInt()}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: _lastAccuracy >= 0.70 ? const Color(0xFF065F46) : const Color(0xFF92400E),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => _playCurrentSentence(isSlow: true),
                          child: const Row(
                            children: [
                              Icon(Icons.volume_up_rounded, size: 14, color: Color(0xFF4F46E5)),
                              SizedBox(width: 3),
                              Text('Nghe lại', style: TextStyle(fontSize: 11, color: Color(0xFF4F46E5), fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'So sánh câu nghe được:',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 6),
                    _buildWordDiffComparison(_inputController.text, currentSentence.targetText),
                    const SizedBox(height: 8),
                    Text(
                      currentSentence.translationVi,
                      style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF475569)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _nextSentence,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 44),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: Text(
                  _currentIndex < totalSentences - 1 ? 'Câu tiếp theo' : 'Hoàn thành bài tập',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    ),
  );
  }

  // Visual Word-by-Word Diff Comparison with LCS
  Widget _buildWordDiffComparison(String userText, String targetText) {
    final cleanUser = userText.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '').trim();
    final userWords = cleanUser.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final targetOriginalWords = targetText.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

    // Map matched target indices using LCS
    final Set<int> matchedTargetIndices = {};
    int uIdx = 0;
    for (int tIdx = 0; tIdx < targetOriginalWords.length; tIdx++) {
      final cleanTargetWord = targetOriginalWords[tIdx].toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
      if (uIdx < userWords.length && userWords[uIdx] == cleanTargetWord) {
        matchedTargetIndices.add(tIdx);
        uIdx++;
      } else {
        // Look ahead 1 word in user input to handle single word insertion/deletion
        if (uIdx + 1 < userWords.length && userWords[uIdx + 1] == cleanTargetWord) {
          matchedTargetIndices.add(tIdx);
          uIdx += 2;
        }
      }
    }

    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: List.generate(targetOriginalWords.length, (idx) {
        final targetOriginal = targetOriginalWords[idx];
        final isMatch = matchedTargetIndices.contains(idx);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: isMatch ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isMatch ? const Color(0xFF86EFAC) : const Color(0xFFFCA5A5),
            ),
          ),
          child: Text(
            targetOriginal,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isMatch ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFinishedScreen() {
    final total = _exercise.sentences.length;
    final done = _completedMap.length;

    // Calculate accuracy and counts
    int perfectCount = 0;
    double totalAccuracy = 0.0;

    for (int i = 0; i < total; i++) {
      final s = _exercise.sentences[i];
      final ans = _userAnswers[i] ?? '';
      final acc = s.calculateAccuracy(ans);
      totalAccuracy += acc;

      if (s.isAccurate(ans)) {
        perfectCount++;
      }
    }

    final avgAccuracy = total > 0 ? (totalAccuracy / total * 100).toInt() : 0;
    final nextExercise = _getNextExercise();
    final hasErrorsToReview = (total - perfectCount) > 0;

    String feedbackBadge = 'Cần luyện tập thêm';
    Color feedbackColor = const Color(0xFFD97706);
    if (avgAccuracy >= 85) {
      feedbackBadge = 'Xuất sắc! Phản xạ rất tốt 🔥';
      feedbackColor = const Color(0xFF059669);
    } else if (avgAccuracy >= 65) {
      feedbackBadge = 'Khá tốt! Cần chú ý âm nối 👏';
      feedbackColor = const Color(0xFF2563EB);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const AppBackButton(),
        title: const Text(
          'Tổng Kết Bài Học',
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          // 1. Header Card with score
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(Icons.celebration_rounded, color: Color(0xFF10B981), size: 32),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Hoàn Thành Bài Tập!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 4),
                Text(
                  _exercise.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.brandPrimary),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: feedbackColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    feedbackBadge,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: feedbackColor),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 16),

                // 3 Stats Boxes
                Row(
                  children: [
                    Expanded(
                      child: _buildResultStatBox(
                        title: 'Độ chính xác',
                        value: '$avgAccuracy%',
                        color: avgAccuracy >= 75 ? const Color(0xFF059669) : const Color(0xFFD97706),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildResultStatBox(
                        title: 'Đã hoàn thành',
                        value: '$done/$total',
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildResultStatBox(
                        title: 'Đúng 100%',
                        value: '$perfectCount câu',
                        color: const Color(0xFF059669),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. Action Buttons Section
          if (hasErrorsToReview) ...[
            ElevatedButton.icon(
              onPressed: _practiceIncorrectSentences,
              icon: const Icon(Icons.fitness_center_rounded, size: 17),
              label: Text(
                'Luyện lại ${total - perfectCount} câu chưa đạt 100% 🎯',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEA580C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 13),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 10),
          ],

          if (nextExercise != null) ...[
            ElevatedButton.icon(
              onPressed: () {
                _stopAllAudio();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => ListeningDictationScreen(exercise: nextExercise)),
                );
              },
              icon: const Icon(Icons.arrow_forward_rounded, size: 17),
              label: Text(
                'Bài tiếp theo: ${nextExercise.title}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.brandPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 10),
          ],

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _resetExercise,
                  icon: const Icon(Icons.replay_rounded, size: 15),
                  label: const Text('Làm lại từ đầu'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF475569),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _stopAllAudio();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.list_alt_rounded, size: 15),
                  label: const Text('Về danh sách'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF475569),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // 3. Section Title: Detailed review of all sentences
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'CHI TIẾT TỪNG CÂU VỪA LUYỆN',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Chạm 🔊 để nghe lại',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // List of sentence cards
          ...List.generate(total, (idx) {
            final s = _exercise.sentences[idx];
            final ans = _userAnswers[idx] ?? '';
            final isAccurate = s.isAccurate(ans);
            final acc = s.calculateAccuracy(ans);
            final pct = (acc * 100).toInt();

            Color badgeColor = const Color(0xFF10B981);
            if (!isAccurate) {
              badgeColor = acc >= 0.5 ? const Color(0xFFF59E0B) : const Color(0xFFEF4444);
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isAccurate ? const Color(0xFFA7F3D0) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Câu ${idx + 1} • $pct%',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: badgeColor),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.volume_up_rounded, size: 20, color: Color(0xFF4F46E5)),
                        tooltip: 'Nghe lại',
                        onPressed: () => _playSpecificSentence(s),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    s.targetText,
                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  if (ans.isNotEmpty && !isAccurate) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Bạn gõ: $ans',
                      style: const TextStyle(fontSize: 12, color: Color(0xFFDC2626)),
                    ),
                  ],
                  if (s.translationVi.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      s.translationVi,
                      style: const TextStyle(fontSize: 11.5, fontStyle: FontStyle.italic, color: Color(0xFF64748B)),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildResultStatBox({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
