import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../models/reading_test_model.dart';
import '../models/reading_result_model.dart';
import '../services/reading_progress_service.dart';
import '../widgets/reading_passage_view.dart';
import '../widgets/reading_question_item.dart';
import '../widgets/reading_matrix_jump_modal.dart';

class ReadingPracticeScreen extends StatefulWidget {
  final ReadingTest test;

  const ReadingPracticeScreen({super.key, required this.test});

  @override
  State<ReadingPracticeScreen> createState() => _ReadingPracticeScreenState();
}

class _ReadingPracticeScreenState extends State<ReadingPracticeScreen>
    with SingleTickerProviderStateMixin {
  final ReadingProgressService _progressService = ReadingProgressService();

  late TabController _tabController;
  int _currentPartIndex = 0; // 0: Passage 1, 1: Passage 2, 2: Passage 3
  double _fontSize = 15.0;
  final Map<int, String> _userAnswers = {};

  Timer? _timer;
  late int _remainingSeconds;
  late int _elapsedSeconds;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _remainingSeconds = widget.test.durationMinutes * 60;
    _elapsedSeconds = 0;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _elapsedSeconds++;
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _openMatrixJumpModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReadingMatrixJumpModal(
        totalQuestions: widget.test.totalQuestions,
        answers: _userAnswers,
        currentQuestionNumber: _getCurrentFirstQuestionNumber(),
        onSelectQuestion: (qNum) {
          _jumpToQuestion(qNum);
        },
        onSubmit: _confirmSubmit,
      ),
    );
  }

  int _getCurrentFirstQuestionNumber() {
    final currentPassage = widget.test.passages[_currentPartIndex];
    final qs = currentPassage.getAllQuestions();
    return qs.isNotEmpty ? qs.first.number : 1;
  }

  void _jumpToQuestion(int qNum) {
    // Find which passage contains this question
    for (int i = 0; i < widget.test.passages.length; i++) {
      final p = widget.test.passages[i];
      for (final q in p.getAllQuestions()) {
        if (q.number == qNum) {
          setState(() {
            _currentPartIndex = i;
          });
          // Switch tab to questions
          _tabController.animateTo(1);
          return;
        }
      }
    }
  }

  void _confirmSubmit() {
    final allQuestions = widget.test.getAllQuestions();
    int unansweredCount = 0;
    for (final q in allQuestions) {
      if ((_userAnswers[q.number] ?? '').trim().isEmpty) {
        unansweredCount++;
      }
    }

    if (unansweredCount > 0) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFF59E0B), size: 22),
              SizedBox(width: 8),
              Text('Chưa làm hết câu hỏi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            'Bạn vẫn còn $unansweredCount / ${widget.test.totalQuestions} câu chưa điền đáp án. Bạn có chắc chắn muốn nộp bài thi không?',
            style: const TextStyle(fontSize: 13.5, color: Color(0xFF475569)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _openMatrixJumpModal();
              },
              child: const Text('Xem lại câu trống', style: TextStyle(color: AppTheme.brandPrimary, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _processSubmission();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Vẫn nộp bài'),
            ),
          ],
        ),
      );
    } else {
      _processSubmission();
    }
  }

  Future<void> _processSubmission() async {
    _timer?.cancel();

    final allQuestions = widget.test.getAllQuestions();
    int correctCount = 0;

    for (final q in allQuestions) {
      final userAns = _userAnswers[q.number] ?? '';
      if (q.isAnswerCorrect(userAns)) {
        correctCount++;
      }
    }

    final bandScore = ReadingTestResult.calculateBandScore(correctCount);

    final result = ReadingTestResult(
      testId: widget.test.id,
      testTitle: widget.test.title,
      completedAt: DateTime.now(),
      durationSeconds: _elapsedSeconds,
      correctCount: correctCount,
      totalQuestions: widget.test.totalQuestions,
      bandScore: bandScore,
      userAnswers: _userAnswers,
    );

    await _progressService.saveTestResult(result);

    if (mounted) {
      context.pushReplacement(
        '/reading/result',
        extra: {
          'test': widget.test,
          'result': result,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPassage = widget.test.passages[_currentPartIndex];
    final passageQuestions = currentPassage.getAllQuestions();
    final firstQ = passageQuestions.isNotEmpty ? passageQuestions.first.number : 1;
    final lastQ = passageQuestions.isNotEmpty ? passageQuestions.last.number : 13;

    int answeredCount = 0;
    for (int i = 1; i <= widget.test.totalQuestions; i++) {
      if ((_userAnswers[i] ?? '').trim().isNotEmpty) {
        answeredCount++;
      }
    }

    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppTheme.brandTextPrimary),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Thoát bài thi?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                content: const Text('Tiến độ làm bài của bài thi hiện tại sẽ không được lưu nếu bạn thoát bây giờ.'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Ở lại')),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pop(context);
                    },
                    child: const Text('Thoát', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.test.title,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: AppTheme.brandTextPrimary,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.timer_outlined, size: 12, color: AppTheme.brandPrimary),
                const SizedBox(width: 4),
                Text(
                  _formatTime(_remainingSeconds),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '• Đã làm: $answeredCount/${widget.test.totalQuestions}',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Matrix Jump icon button
          IconButton(
            tooltip: 'Xem danh sách câu hỏi',
            icon: const Icon(Icons.grid_view_rounded, color: AppTheme.brandPrimary, size: 21),
            onPressed: _openMatrixJumpModal,
          ),
          // Submit Button
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
            child: ElevatedButton(
              onPressed: _confirmSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.brandPrimary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Nộp bài', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(84),
          child: Column(
            children: [
              // 1. Passage Selector (Part 1, Part 2, Part 3)
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                ),
                child: Row(
                  children: List.generate(widget.test.passages.length, (idx) {
                    final isCurrent = idx == _currentPartIndex;
                    return Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _currentPartIndex = idx;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isCurrent ? AppTheme.brandPrimary : Colors.transparent,
                                width: 2.5,
                              ),
                            ),
                          ),
                          child: Text(
                            'Part ${idx + 1}',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                              color: isCurrent ? AppTheme.brandPrimary : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // 2. Dual Tab (Bài đọc vs Câu hỏi)
              TabBar(
                controller: _tabController,
                indicatorColor: AppTheme.brandPrimary,
                indicatorWeight: 2.5,
                labelColor: AppTheme.brandPrimary,
                unselectedLabelColor: const Color(0xFF64748B),
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: [
                  const Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.article_outlined, size: 16),
                        SizedBox(width: 6),
                        Text('Bài Đọc (Passage)'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.help_outline_rounded, size: 16),
                        const SizedBox(width: 6),
                        Text('Câu Hỏi (Q$firstQ - Q$lastQ)'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: PASSAGE VIEW
          ReadingPassageView(
            passage: currentPassage,
            fontSize: _fontSize,
            onZoomIn: () {
              if (_fontSize < 22) setState(() => _fontSize += 1);
            },
            onZoomOut: () {
              if (_fontSize > 12) setState(() => _fontSize -= 1);
            },
          ),

          // TAB 2: QUESTIONS LIST
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final group in currentPassage.questionGroups) ...[
                  // Group Instructions Callout
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.chipIndigoBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.brandPrimary.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      group.instructions,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.brandPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),

                  // Questions in group
                  for (final q in group.questions)
                    ReadingQuestionItem(
                      question: q,
                      currentAnswer: _userAnswers[q.number] ?? '',
                      onAnswerChanged: (val) {
                        setState(() {
                          _userAnswers[q.number] = val;
                        });
                      },
                    ),
                ],
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
      // Floating switch pill between Passage & Questions
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final nextIdx = _tabController.index == 0 ? 1 : 0;
          _tabController.animateTo(nextIdx);
        },
        backgroundColor: AppTheme.brandPrimary,
        icon: Icon(
          _tabController.index == 0 ? Icons.help_outline_rounded : Icons.article_outlined,
          color: Colors.white,
          size: 18,
        ),
        label: Text(
          _tabController.index == 0 ? 'Xem câu hỏi (Q$firstQ-Q$lastQ)' : 'Xem lại bài đọc',
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
