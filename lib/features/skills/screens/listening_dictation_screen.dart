import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../../app/theme.dart';
import '../models/dictation_model.dart';
import '../data/listening_mock_data.dart';

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
  final FlutterTts _flutterTts = FlutterTts();
  final TextEditingController _inputController = TextEditingController();

  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _showHint = false;
  bool _isChecked = false;
  bool _isRevealed = false;
  double _lastAccuracy = 0.0;
  bool _isFinished = false;

  // Track progress and answers across sentences
  final Map<int, String> _userAnswers = {};
  final Map<int, bool> _completedMap = {};

  @override
  void initState() {
    super.initState();
    _exercise = widget.exercise ?? ListeningMockData.dictationExercises.first;
    _initTts();

    // Auto-play initial sentence after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _playCurrentSentence(isSlow: false);
      }
    });
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.setLanguage("en-GB");
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
    try {
      _flutterTts.stop();
    } catch (_) {}
    _inputController.dispose();
    super.dispose();
  }

  void _playCurrentSentence({required bool isSlow}) async {
    if (_isFinished) return;
    try {
      await _flutterTts.stop();
      if (!mounted) return;
      setState(() => _isPlaying = true);
      await _flutterTts.setSpeechRate(isSlow ? 0.30 : 0.46);
      final sentence = _exercise.sentences[_currentIndex];
      await _flutterTts.speak(sentence.targetText);
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
  }

  void _revealAnswer() {
    final current = _exercise.sentences[_currentIndex];
    setState(() {
      _isChecked = true;
      _isRevealed = true;
      _showHint = true;
      _lastAccuracy = current.calculateAccuracy(_inputController.text);
    });
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
  }

  void _prevSentence() {
    if (_currentIndex > 0) {
      _saveCurrentAnswer();
      setState(() {
        _currentIndex--;
        _loadSentenceState();
      });
      _playCurrentSentence(isSlow: false);
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

  void _showFinishConfirmation() {
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
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
          TextButton.icon(
            onPressed: _showFinishConfirmation,
            icon: const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppTheme.brandPrimary),
            label: const Text(
              'Kết thúc',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppTheme.brandPrimary),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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

            // 3. Sentence Navigation (Câu trước ⏮ & Đáp án 👁 & Câu sau ⏭)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _currentIndex > 0 ? _prevSentence : null,
                    icon: const Icon(Icons.skip_previous_rounded, size: 16),
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
                    icon: const Icon(Icons.skip_next_rounded, size: 16),
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

            // 4. Input TextField (Dynamic onChanged triggers rebuild)
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
              ElevatedButton.icon(
                onPressed: _nextSentence,
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: Text(
                  _currentIndex < totalSentences - 1 ? 'Câu tiếp theo ➔' : 'Hoàn thành bài tập ➔',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ],
            const SizedBox(height: 32),
          ],
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
    final percent = total > 0 ? (done / total * 100).toInt() : 0;

    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Tổng Kết Bài Học', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(36),
                ),
                child: const Icon(Icons.celebration_rounded, color: Color(0xFF10B981), size: 40),
              ),
              const SizedBox(height: 14),
              const Text(
                'Hoàn Thành!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 6),
              Text(
                _exercise.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppTheme.brandPrimary),
              ),
              const SizedBox(height: 6),
              Text(
                'Bạn đã hoàn thành $done/$total câu (Đạt $percent% bài tập).',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _resetExercise,
                icon: const Icon(Icons.replay_rounded, size: 16),
                label: const Text('Luyện lại bài này'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.brandPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.list_alt_rounded, size: 16),
                label: const Text('Về danh sách bài nghe'),
                style: TextButton.styleFrom(foregroundColor: const Color(0xFF64748B)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
