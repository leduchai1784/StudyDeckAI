import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../services/roadmap_progress_service.dart';
import '../data/grammar_lessons_data.dart';
import '../models/grammar_lesson_model.dart';

class GrammarLessonDetailScreen extends StatefulWidget {
  final String lessonId;

  const GrammarLessonDetailScreen({
    super.key,
    required this.lessonId,
  });

  @override
  State<GrammarLessonDetailScreen> createState() => _GrammarLessonDetailScreenState();
}

class _GrammarLessonDetailScreenState extends State<GrammarLessonDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RoadmapProgressService _roadmapService = RoadmapProgressService();

  GrammarLessonModel? _lesson;
  int _currentQuestionIndex = 0;
  final Map<int, int> _selectedAnswers = {}; // questionIndex -> optionIndex
  bool _isLessonCompleted = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _lesson = GrammarLessonsData.getLessonById(widget.lessonId) ??
        GrammarLessonsData.getAllLessons().first;
    _checkInitialCompletion();
  }

  Future<void> _checkInitialCompletion() async {
    try {
      final allCompleted = await _roadmapService.getAllCompletedLessonIds();
      if (mounted && _lesson != null && allCompleted.contains(_lesson!.id)) {
        setState(() {
          _isLessonCompleted = true;
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onOptionSelected(int qIndex, int optIndex) {
    if (_selectedAnswers.containsKey(qIndex)) return; // Không cho đổi sau khi đã hiện giải thích
    setState(() {
      _selectedAnswers[qIndex] = optIndex;
    });
  }

  Future<void> _completeLesson() async {
    if (_lesson == null) return;
    await _roadmapService.recordLessonCompleted(
      _lesson!.id,
      durationMinutes: _lesson!.durationMinutes,
      lessonTitle: _lesson!.title,
    );

    setState(() => _isLessonCompleted = true);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text('🎉 Đã hoàn thành bài học: ${_lesson!.titleEn}! Tiến độ mục tiêu hôm nay đã được cập nhật.'),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF16A34A),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lesson = _lesson;
    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bài học ngữ pháp')),
        body: const Center(child: Text('Không tìm thấy bài học')),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppTheme.brandTextPrimary),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lesson.titleEn,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppTheme.brandTextPrimary,
              ),
            ),
            Text(
              lesson.titleVi,
              style: const TextStyle(
                fontSize: 11.5,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          if (_isLessonCompleted)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF86EFAC)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded, size: 13, color: Color(0xFF16A34A)),
                  SizedBox(width: 4),
                  Text(
                    'Đã hoàn thành',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF15803D),
                    ),
                  ),
                ],
              ),
            ),
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppTheme.brandPrimary.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars_rounded, size: 14, color: AppTheme.brandPrimary),
                const SizedBox(width: 4),
                Text(
                  lesson.bandText,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.brandPrimary,
          unselectedLabelColor: const Color(0xFF64748B),
          indicatorColor: AppTheme.brandPrimary,
          indicatorWeight: 2.5,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
          tabs: [
            const Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book_rounded, size: 16),
                  SizedBox(width: 6),
                  Text('Lý thuyết'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.quiz_outlined, size: 16),
                  const SizedBox(width: 6),
                  Text('Luyện tập (${lesson.questions.length})'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Theory
          _buildTheoryTab(lesson),

          // Tab 2: Exercises
          _buildExerciseTab(lesson),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(lesson),
    );
  }

  Widget _buildTheoryTab(GrammarLessonModel lesson) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Banner Callout
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFC7D2FE)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline_rounded, color: AppTheme.brandPrimary, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Nắm vững quy tắc ngữ pháp cốt lõi để đạt tiêu chí Grammatical Range & Accuracy trong kỳ thi IELTS.',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF3730A3),
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Theory Sections
          ...lesson.theorySections.map((sec) => _buildTheorySectionCard(sec)),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildTheorySectionCard(GrammarTheorySection section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          Text(
            section.sectionTitle,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppTheme.brandTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            section.overview,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF475569),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),

          // Rows
          ...section.rows.map((r) => _buildTheoryRowItem(r)),

          if (section.examTips.isNotEmpty) ...[
            const Divider(height: 24, color: Color(0xFFF1F5F9)),
            const Text(
              '💡 Mẹo thực chiến trong bài thi:',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            ...section.examTips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: AppTheme.brandPrimary, fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text(
                        tip,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF334155), height: 1.35),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTheoryRowItem(GrammarTheoryRow row) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppTheme.brandPrimary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                row.title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            row.usage,
            style: const TextStyle(fontSize: 12, color: Color(0xFF475569), height: 1.35),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Công thức: ${row.formula}',
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Ví dụ: "${row.example}"',
            style: const TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Color(0xFF2563EB),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseTab(GrammarLessonModel lesson) {
    if (lesson.questions.isEmpty) {
      return const Center(child: Text('Chưa có câu hỏi luyện tập'));
    }

    final q = lesson.questions[_currentQuestionIndex];
    final selectedOpt = _selectedAnswers[_currentQuestionIndex];
    final isAnswered = selectedOpt != null;
    final isCorrect = isAnswered && selectedOpt == q.correctIndex;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Counter & Progress bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CÂU ${_currentQuestionIndex + 1} / ${lesson.questions.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brandPrimary,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Đã làm: ${_selectedAnswers.length}/${lesson.questions.length}',
                style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / lesson.questions.length,
              minHeight: 6,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.brandPrimary),
            ),
          ),
          const SizedBox(height: 18),

          // Question Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chọn đáp án đúng nhất để hoàn thành câu:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  q.questionText,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandTextPrimary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 4 Options (A, B, C, D)
          ...List.generate(q.options.length, (idx) {
            final opt = q.options[idx];
            final optionLabel = String.fromCharCode(65 + idx); // A, B, C, D

            Color bgColor = Colors.white;
            Color borderColor = const Color(0xFFE2E8F0);
            Color labelBg = const Color(0xFFF1F5F9);
            Color labelTextColor = const Color(0xFF475569);

            if (isAnswered) {
              if (idx == q.correctIndex) {
                // Correct answer is always highlighted green
                bgColor = const Color(0xFFF0FDF4);
                borderColor = const Color(0xFF86EFAC);
                labelBg = const Color(0xFF22C55E);
                labelTextColor = Colors.white;
              } else if (idx == selectedOpt) {
                // Wrong user selection is highlighted red
                bgColor = const Color(0xFFFEF2F2);
                borderColor = const Color(0xFFFCA5A5);
                labelBg = const Color(0xFFEF4444);
                labelTextColor = Colors.white;
              }
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () => _onOptionSelected(_currentQuestionIndex, idx),
                  borderRadius: BorderRadius.circular(10),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: labelBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              optionLabel,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: labelTextColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            opt,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isAnswered && (idx == q.correctIndex || idx == selectedOpt)
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: AppTheme.brandTextPrimary,
                            ),
                          ),
                        ),
                        if (isAnswered && idx == q.correctIndex)
                          const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 20)
                        else if (isAnswered && idx == selectedOpt)
                          const Icon(Icons.cancel_rounded, color: Color(0xFFDC2626), size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          // Vietnamese Explanation Box (Appears after answer is selected)
          if (isAnswered) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isCorrect ? const Color(0xFFF0FDF4) : const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isCorrect ? const Color(0xFFBBF7D0) : const Color(0xFFFDE68A),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle_outline_rounded : Icons.info_outline_rounded,
                        size: 18,
                        color: isCorrect ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isCorrect ? 'Chính xác! 👏' : 'Chưa đúng rồi! Hãy xem giải thích:',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: isCorrect ? const Color(0xFF15803D) : const Color(0xFFB45309),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    q.explanation,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isCorrect ? const Color(0xFF166534) : const Color(0xFF92400E),
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildBottomBar(GrammarLessonModel lesson) {
    final bool hasNext = _currentQuestionIndex + 1 < lesson.questions.length;
    final bool hasPrev = _currentQuestionIndex > 0;
    final bool isAllAnswered = _selectedAnswers.length >= lesson.questions.length;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (_tabController.index == 1 && hasPrev) ...[
              OutlinedButton(
                onPressed: () {
                  setState(() => _currentQuestionIndex--);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Câu trước', style: TextStyle(color: Color(0xFF475569))),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (_tabController.index == 0) {
                    // Switch to exercise tab
                    _tabController.animateTo(1);
                  } else {
                    if (hasNext) {
                      setState(() => _currentQuestionIndex++);
                    } else if (isAllAnswered || !_isLessonCompleted) {
                      _completeLesson();
                    } else {
                      context.pop();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  backgroundColor: AppTheme.brandPrimary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  _tabController.index == 0
                      ? 'Bắt đầu làm bài tập (${lesson.questions.length} câu)'
                      : (hasNext
                          ? 'Câu tiếp theo →'
                          : (_isLessonCompleted ? 'Quay lại Trang Chủ' : 'Hoàn thành bài học 🎉')),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
