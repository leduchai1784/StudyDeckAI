import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../models/edu_word.dart';
import '../../../models/user_deck_progress.dart';
import '../../../services/eduwords_service.dart';
import '../../../services/flashcard_progress_service.dart';
import '../../../services/tts_service.dart';

class DeckQuizScreen extends StatefulWidget {
  final String deckId;
  final String deckTitle;

  const DeckQuizScreen({
    super.key,
    required this.deckId,
    required this.deckTitle,
  });

  @override
  State<DeckQuizScreen> createState() => _DeckQuizScreenState();
}

class _QuizQuestion {
  final EduWord word;
  final List<String> options;
  final int correctIndex;

  _QuizQuestion({
    required this.word,
    required this.options,
    required this.correctIndex,
  });
}

class _DeckQuizScreenState extends State<DeckQuizScreen> {
  final EduwordsService _eduwordsService = EduwordsService();
  final FlashcardProgressService _progressService = FlashcardProgressService();
  final TtsService _ttsService = TtsService();

  bool _isLoading = true;
  List<_QuizQuestion> _questions = [];

  int _currentIndex = 0;
  int? _selectedAnswerIndex;
  bool _hasAnswered = false;
  int _correctAnswers = 0;
  bool _isQuizFinished = false;

  @override
  void initState() {
    super.initState();
    _ttsService.init();
    _generateQuiz();
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  Future<void> _generateQuiz() async {
    setState(() => _isLoading = true);

    final upperKey = widget.deckId.toUpperCase();
    final grouped = await _eduwordsService.fetchWordsByLevel();
    final words = grouped[upperKey] ?? [];

    if (words.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _questions = [];
        });
      }
      return;
    }

    // Collect distractors pool
    final List<String> allMeanings = [];
    for (final w in words) {
      if (w.viword.isNotEmpty) {
        allMeanings.add(w.viword);
      }
    }
    // Also include other levels as distractors if deck has few words
    if (allMeanings.length < 4) {
      grouped.forEach((_, list) {
        for (final w in list) {
          if (w.viword.isNotEmpty && !allMeanings.contains(w.viword)) {
            allMeanings.add(w.viword);
          }
        }
      });
    }

    final rng = Random();
    final shuffledWords = List<EduWord>.from(words)..shuffle(rng);
    final quizCards = shuffledWords.take(min(15, shuffledWords.length)).toList();

    final List<_QuizQuestion> questions = [];
    for (final card in quizCards) {
      final correctAnswer = card.viword;
      final Set<String> distractorSet = {correctAnswer};

      final otherMeanings = allMeanings.where((m) => m != correctAnswer).toList()..shuffle(rng);
      for (final m in otherMeanings) {
        distractorSet.add(m);
        if (distractorSet.length == 4) break;
      }

      final optionsList = distractorSet.toList()..shuffle(rng);
      final correctIdx = optionsList.indexOf(correctAnswer);

      questions.add(_QuizQuestion(
        word: card,
        options: optionsList,
        correctIndex: correctIdx,
      ));
    }

    if (mounted) {
      setState(() {
        _questions = questions;
        _currentIndex = 0;
        _selectedAnswerIndex = null;
        _hasAnswered = false;
        _correctAnswers = 0;
        _isQuizFinished = false;
        _isLoading = false;
      });

      _playCurrentWordAudio();
    }
  }

  void _playCurrentWordAudio() {
    if (_questions.isNotEmpty && _currentIndex < _questions.length) {
      _ttsService.speak(_questions[_currentIndex].word.title);
    }
  }

  void _selectAnswer(int optionIndex) {
    if (_hasAnswered) return;

    final question = _questions[_currentIndex];
    final isCorrect = optionIndex == question.correctIndex;

    setState(() {
      _selectedAnswerIndex = optionIndex;
      _hasAnswered = true;
      if (isCorrect) {
        _correctAnswers++;
      }
    });

    // Update card learning stat
    _progressService.updateCardAnswer(
      widget.deckId,
      question.word.id,
      isCorrect,
    );

    // Auto advance after 1.2 seconds if user doesn't press next
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted && _hasAnswered) {
        _goToNextQuestion();
      }
    });
  }

  void _goToNextQuestion() {
    if (_currentIndex + 1 < _questions.length) {
      setState(() {
        _currentIndex++;
        _selectedAnswerIndex = null;
        _hasAnswered = false;
      });
      _playCurrentWordAudio();
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    final total = _questions.length;
    final double score = total > 0 ? (_correctAnswers / total) * 100 : 0.0;

    final session = QuizSession(
      id: 'quiz_${DateTime.now().millisecondsSinceEpoch}',
      deckId: widget.deckId,
      totalQuestions: total,
      correctAnswers: _correctAnswers,
      score: score,
      completedAt: DateTime.now(),
    );

    await _progressService.recordQuizResult(session);

    if (mounted) {
      setState(() {
        _isQuizFinished = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.brandSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.brandTextPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Kiểm tra: ${widget.deckTitle}',
          style: const TextStyle(
            color: AppTheme.brandTextPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _questions.isEmpty
              ? const Center(child: Text('Không đủ từ vựng để tạo bài kiểm tra.'))
              : _isQuizFinished
                  ? _buildQuizResultView()
                  : _buildQuizActiveView(),
    );
  }

  // Active Quiz View
  Widget _buildQuizActiveView() {
    final currentQ = _questions[_currentIndex];
    final progressVal = (_currentIndex + 1) / _questions.length;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Progress Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Câu ${_currentIndex + 1} / ${_questions.length}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandPrimary,
                  ),
                ),
                Text(
                  'Đúng: $_correctAnswers',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.brandSuccess,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progressVal,
                minHeight: 6,
                backgroundColor: AppTheme.brandBorder,
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.brandPrimary),
              ),
            ),
            const SizedBox(height: 24),

            // Question Word Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                color: AppTheme.brandSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.brandBorder),
              ),
              child: Column(
                children: [
                  Text(
                    currentQ.word.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brandTextPrimary,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  if (currentQ.word.transcription.isNotEmpty)
                    Text(
                      currentQ.word.transcription,
                      style: AppTheme.ipaStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => _ttsService.speak(currentQ.word.title),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.chipIndigoBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.volume_up_rounded, color: AppTheme.chipIndigoText, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Phát âm',
                            style: TextStyle(
                              color: AppTheme.chipIndigoText,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'CHỌN NGHĨA TIẾNG VIỆT ĐÚNG',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppTheme.brandTextSecondary,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 10),

            // Options List
            Expanded(
              child: ListView.separated(
                itemCount: currentQ.options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final optionText = currentQ.options[index];
                  final isSelected = _selectedAnswerIndex == index;
                  final isCorrect = index == currentQ.correctIndex;

                  Color bgColor = AppTheme.brandSurface;
                  Color borderColor = AppTheme.brandBorder;
                  Color textColor = AppTheme.brandTextPrimary;
                  Widget? trailingIcon;

                  if (_hasAnswered) {
                    if (isCorrect) {
                      bgColor = AppTheme.tintGreenBg;
                      borderColor = AppTheme.brandSuccess;
                      textColor = AppTheme.tintGreenText;
                      trailingIcon = const Icon(Icons.check_circle, color: AppTheme.brandSuccess, size: 20);
                    } else if (isSelected) {
                      bgColor = AppTheme.brandError.withValues(alpha: 0.1);
                      borderColor = AppTheme.brandError;
                      textColor = AppTheme.brandError;
                      trailingIcon = const Icon(Icons.cancel, color: AppTheme.brandError, size: 20);
                    }
                  } else if (isSelected) {
                    bgColor = AppTheme.chipIndigoBg;
                    borderColor = AppTheme.brandPrimary;
                    textColor = AppTheme.brandPrimary;
                  }

                  return InkWell(
                    onTap: () => _selectAnswer(index),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: borderColor,
                          width: isSelected || (_hasAnswered && isCorrect) ? 1.6 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: isSelected && !_hasAnswered ? AppTheme.brandPrimary : AppTheme.brandBackground,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              String.fromCharCode(65 + index), // A, B, C, D
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: isSelected && !_hasAnswered ? Colors.white : AppTheme.brandTextSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              optionText,
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: textColor,
                              ),
                            ),
                          ),
                          if (trailingIcon != null) trailingIcon,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            if (_hasAnswered)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _goToNextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.brandPrimary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    _currentIndex + 1 < _questions.length ? 'Câu tiếp theo →' : 'Xem kết quả kiểm tra',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Quiz Result View
  Widget _buildQuizResultView() {
    final total = _questions.length;
    final double score = total > 0 ? (_correctAnswers / total) * 100 : 0.0;
    final isPass = score >= 70;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: isPass ? AppTheme.tintGreenBg : AppTheme.brandAccentLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPass ? Icons.emoji_events_rounded : Icons.psychology_outlined,
                  color: isPass ? AppTheme.tintGreenText : AppTheme.tintAmberText,
                  size: 40,
                ),
              ),
              const SizedBox(height: 18),

              Text(
                isPass ? 'Xuất sắc! 🎉' : 'Hoàn thành bài kiểm tra! 💪',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brandTextPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isPass
                    ? 'Bạn đã ghi nhớ rất tốt từ vựng của bộ thẻ này.'
                    : 'Hãy ôn tập thêm các từ chưa nhớ để củng cố trí nhớ nhé.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13.5, color: AppTheme.brandTextSecondary),
              ),
              const SizedBox(height: 24),

              // Score Card
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                decoration: BoxDecoration(
                  color: AppTheme.brandSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.brandBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '${score.toInt()}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isPass ? AppTheme.tintGreenText : AppTheme.tintAmberText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text('Điểm số / 100', style: TextStyle(fontSize: 11, color: AppTheme.brandTextMuted)),
                      ],
                    ),
                    Container(height: 36, width: 1, color: AppTheme.brandBorder),
                    Column(
                      children: [
                        Text(
                          '$_correctAnswers / $total',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.brandSuccess,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text('Câu đúng', style: TextStyle(fontSize: 11, color: AppTheme.brandTextMuted)),
                      ],
                    ),
                    Container(height: 36, width: 1, color: AppTheme.brandBorder),
                    Column(
                      children: [
                        Text(
                          '${total - _correctAnswers}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.brandError,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text('Câu sai', style: TextStyle(fontSize: 11, color: AppTheme.brandTextMuted)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 2 Action Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _generateQuiz,
                  icon: const Icon(Icons.refresh_rounded, size: 20, color: Colors.white),
                  label: const Text(
                    'Làm lại bài kiểm tra',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.brandPrimary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppTheme.brandBorder),
                    foregroundColor: AppTheme.brandTextPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Quay về bộ thẻ'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
