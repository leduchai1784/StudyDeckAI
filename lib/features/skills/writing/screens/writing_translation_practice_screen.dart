import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../../shared/widgets/app_back_button.dart';
import '../data/writing_translation_repository.dart';
import '../models/writing_translation_model.dart';

class WritingTranslationPracticeScreen extends StatefulWidget {
  final WritingTranslationExercise exercise;
  final int initialSentenceIndex;

  const WritingTranslationPracticeScreen({
    super.key,
    required this.exercise,
    this.initialSentenceIndex = 0,
  });

  @override
  State<WritingTranslationPracticeScreen> createState() =>
      _WritingTranslationPracticeScreenState();
}

class _WritingTranslationPracticeScreenState
    extends State<WritingTranslationPracticeScreen> {
  late int _currentIndex;
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // Word masking state per sentence
  final Map<int, Set<int>> _revealedWordIndices = {};
  final Map<int, bool> _revealedAll = {};

  // Submission state
  bool _isSubmitted = false;
  bool _isCorrect = false;
  String _lastSubmittedText = '';
  Set<int> _completedSentenceIndices = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialSentenceIndex.clamp(
      0,
      widget.exercise.sentences.isEmpty ? 0 : widget.exercise.sentences.length - 1,
    );
    _loadProgress();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadProgress() async {
    final completed = await WritingTranslationRepository.instance
        .getCompletedSentenceIndices(widget.exercise.exerciseId);
    if (mounted) {
      setState(() {
        _completedSentenceIndices = completed;
      });
    }
  }

  WritingTranslationSentence get _currentSentence =>
      widget.exercise.sentences[_currentIndex];

  List<String> get _answerWords {
    final text = _currentSentence.answer.trim();
    if (text.isEmpty) return [];
    return text.split(RegExp(r'\s+'));
  }

  bool _isWordRevealed(int wordIndex) {
    if (_revealedAll[_currentIndex] == true) return true;
    final set = _revealedWordIndices[_currentIndex];
    return set != null && set.contains(wordIndex);
  }

  void _toggleWordReveal(int wordIndex) {
    setState(() {
      _revealedWordIndices.putIfAbsent(_currentIndex, () => <int>{});
      if (_revealedWordIndices[_currentIndex]!.contains(wordIndex)) {
        _revealedWordIndices[_currentIndex]!.remove(wordIndex);
      } else {
        _revealedWordIndices[_currentIndex]!.add(wordIndex);
      }
    });
  }

  void _toggleRevealAll() {
    setState(() {
      final current = _revealedAll[_currentIndex] ?? false;
      _revealedAll[_currentIndex] = !current;
    });
  }

  String _maskWord(String word) {
    if (word.length <= 1) return word;
    // Extract trailing punctuation if any
    final puncMatch = RegExp(r'[.,!?;:"]+$').firstMatch(word);
    String core = word;
    String punct = '';
    if (puncMatch != null) {
      punct = puncMatch.group(0)!;
      core = word.substring(0, word.length - punct.length);
    }
    if (core.length <= 1) return word;
    final masked = core[0] + ('*' * (core.length - 1));
    return masked + punct;
  }

  void _handleSubmit() {
    final input = _inputController.text.trim();
    if (input.isEmpty) return;

    final normInput = _normalizeText(input);
    final normAnswer = _normalizeText(_currentSentence.answer);

    final correct = normInput == normAnswer;

    setState(() {
      _isSubmitted = true;
      _isCorrect = correct;
      _lastSubmittedText = input;
    });

    if (correct) {
      _completedSentenceIndices.add(_currentIndex);
      WritingTranslationRepository.instance
          .markSentenceCompleted(widget.exercise.exerciseId, _currentIndex);
    }
  }

  String _normalizeText(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  void _goToSentence(int newIndex) {
    if (newIndex < 0 || newIndex >= widget.exercise.sentences.length) return;
    setState(() {
      _currentIndex = newIndex;
      _inputController.clear();
      _isSubmitted = false;
      _isCorrect = false;
      _lastSubmittedText = '';
    });
  }

  void _showSentencePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Danh Sách Câu Hỏi (${widget.exercise.sentences.length} câu)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brandTextPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(widget.exercise.sentences.length, (idx) {
                    final isCurrent = idx == _currentIndex;
                    final isCompleted = _completedSentenceIndices.contains(idx);

                    Color bg = const Color(0xFFF1F5F9);
                    Color textCol = const Color(0xFF475569);
                    Border? border;

                    if (isCompleted) {
                      bg = const Color(0xFFDCFCE7);
                      textCol = const Color(0xFF15803D);
                    }
                    if (isCurrent) {
                      bg = AppTheme.brandPrimary;
                      textCol = Colors.white;
                      border = Border.all(color: AppTheme.brandPrimary, width: 2);
                    }

                    return InkWell(
                      onTap: () {
                        Navigator.pop(ctx);
                        _goToSentence(idx);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(8),
                          border: border,
                        ),
                        child: Text(
                          '${idx + 1}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textCol,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.exercise.sentences.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.exercise.title)),
        body: const Center(child: Text('Chưa có câu hỏi cho bài tập này.')),
      );
    }

    final total = widget.exercise.sentences.length;
    final progress = (total > 0) ? (_currentIndex + 1) / total : 0.0;
    final revealAll = _revealedAll[_currentIndex] ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const AppBackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.exercise.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppTheme.brandTextPrimary,
              ),
            ),
            Text(
              widget.exercise.bandTarget,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: _showSentencePickerBottomSheet,
            icon: const Icon(Icons.grid_view_rounded, size: 16, color: AppTheme.brandPrimary),
            label: Text(
              '${_currentIndex + 1}/$total',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.brandPrimary,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.brandPrimary),
            minHeight: 3,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Vietnamese prompt card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2FF),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'CÂU ${_currentIndex + 1} / $total',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.brandPrimary,
                                ),
                              ),
                            ),
                            const Spacer(),
                            if (_completedSentenceIndices.contains(_currentIndex))
                              const Row(
                                children: [
                                  Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    'Đã hoàn thành',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF16A34A),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _currentSentence.vi,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 2. Word Masking hint card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.touch_app_outlined, size: 15, color: Color(0xFF475569)),
                                SizedBox(width: 6),
                                Text(
                                  'Chạm vào từ để xem gợi ý:',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF475569),
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: _toggleRevealAll,
                              borderRadius: BorderRadius.circular(6),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                child: Text(
                                  revealAll ? 'Ẩn gợi ý' : 'Hiện tất cả',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.brandPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 8,
                          children: List.generate(_answerWords.length, (wIdx) {
                            final word = _answerWords[wIdx];
                            final isRevealed = _isWordRevealed(wIdx);
                            final displayText = isRevealed ? word : _maskWord(word);

                            return InkWell(
                              onTap: () => _toggleWordReveal(wIdx),
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                decoration: BoxDecoration(
                                  color: isRevealed ? const Color(0xFFFEF3C7) : Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isRevealed ? const Color(0xFFF59E0B) : const Color(0xFFCBD5E1),
                                  ),
                                ),
                                child: Text(
                                  displayText,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isRevealed ? FontWeight.bold : FontWeight.w500,
                                    color: isRevealed ? const Color(0xFF92400E) : const Color(0xFF334155),
                                    fontFamily: isRevealed ? null : 'monospace',
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 3. User Input Area
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _inputController,
                          focusNode: _focusNode,
                          maxLines: 3,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _handleSubmit(),
                          style: const TextStyle(fontSize: 14, height: 1.4),
                          decoration: const InputDecoration(
                            hintText: 'Nhập câu tiếng Anh dịch của bạn tại đây...',
                            hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                            contentPadding: EdgeInsets.all(12),
                            border: InputBorder.none,
                          ),
                        ),
                        const Divider(height: 1, color: Color(0xFFE2E8F0)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  _inputController.clear();
                                  setState(() {
                                    _isSubmitted = false;
                                  });
                                },
                                icon: const Icon(Icons.clear_all_rounded, size: 16, color: Color(0xFF94A3B8)),
                                label: const Text(
                                  'XOÁ HẾT',
                                  style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.bold),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: _handleSubmit,
                                icon: const Icon(Icons.send_rounded, size: 14),
                                label: const Text('NỘP (ENTER)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.brandPrimary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 4. Feedback & Answer Box
                  if (_isSubmitted) ...[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _isCorrect ? const Color(0xFFF0FDF4) : const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isCorrect ? const Color(0xFF86EFAC) : const Color(0xFFFDE68A),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _isCorrect ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                                color: _isCorrect ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _isCorrect
                                      ? '✓ Bạn đã gõ đúng tất cả các từ!'
                                      : 'So sánh bài làm với câu chuẩn bên dưới:',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: _isCorrect ? const Color(0xFF15803D) : const Color(0xFF92400E),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '💡 ĐÁP ÁN CHUẨN:',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF475569),
                            ),
                          ),
                          const SizedBox(height: 4),
                          SelectableText(
                            _currentSentence.answer,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                              height: 1.4,
                            ),
                          ),
                          if (!_isCorrect && _lastSubmittedText.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            const Text(
                              'BÀI BẠN GÕ:',
                              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _lastSubmittedText,
                              style: const TextStyle(fontSize: 13, color: Color(0xFFDC2626)),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Navigation Controls
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: _currentIndex > 0 ? () => _goToSentence(_currentIndex - 1) : null,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 14),
                  label: const Text('Câu trước'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                TextButton.icon(
                  onPressed: _showSentencePickerBottomSheet,
                  icon: const Icon(Icons.format_list_numbered_rounded, size: 18),
                  label: Text('Câu ${_currentIndex + 1}/$total'),
                ),
                ElevatedButton.icon(
                  onPressed: _currentIndex < total - 1 ? () => _goToSentence(_currentIndex + 1) : null,
                  icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  label: const Text('Câu sau'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.brandPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
