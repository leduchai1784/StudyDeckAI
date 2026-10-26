import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../../shared/widgets/app_back_button.dart';
import '../data/writing_translation_repository.dart';
import '../models/writing_translation_model.dart';
import 'writing_translation_practice_screen.dart';

class WritingTranslationTopicsScreen extends StatefulWidget {
  final WritingTranslationStepMeta stepMeta;

  const WritingTranslationTopicsScreen({
    super.key,
    required this.stepMeta,
  });

  @override
  State<WritingTranslationTopicsScreen> createState() =>
      _WritingTranslationTopicsScreenState();
}

class _WritingTranslationTopicsScreenState
    extends State<WritingTranslationTopicsScreen> {
  bool _isLoading = true;
  List<WritingTranslationExercise> _exercises = [];
  Map<String, int> _completedCounts = {};

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    setState(() => _isLoading = true);

    final list = await WritingTranslationRepository.instance
        .getExercisesByStep(widget.stepMeta.step);
    final counts = <String, int>{};
    for (final ex in list) {
      final c = await WritingTranslationRepository.instance
          .getCompletedCountForExercise(ex.exerciseId);
      counts[ex.exerciseId] = c;
    }

    if (mounted) {
      setState(() {
        _exercises = list;
        _completedCounts = counts;
        _isLoading = false;
      });
    }
  }

  int get _totalCompletedSentences {
    int sum = 0;
    for (final c in _completedCounts.values) {
      sum += c;
    }
    return sum;
  }

  int get _totalSentences {
    return _exercises.fold<int>(0, (acc, e) => acc + e.sentences.length);
  }

  @override
  Widget build(BuildContext context) {
    final meta = widget.stepMeta;
    final totalDone = _totalCompletedSentences;
    final totalAll = _totalSentences;
    final double progress = totalAll > 0 ? (totalDone / totalAll).clamp(0.0, 1.0) : 0.0;

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
              meta.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.brandTextPrimary,
              ),
            ),
            Text(
              '${meta.subtitle} • ${_exercises.length} chủ đề',
              style: const TextStyle(
                fontSize: 11.5,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.brandPrimary),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Step Overview Summary Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.brandBorder),
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
                                color: AppTheme.tintIndigoBg,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                meta.badge.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.brandPrimary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              totalDone > 0
                                  ? 'Đã học $totalDone / $totalAll ${meta.step == 5 ? 'đoạn' : 'câu'}'
                                  : '$totalAll ${meta.step == 5 ? 'đoạn essay' : 'câu song ngữ'}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          meta.description,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF475569),
                            height: 1.4,
                          ),
                        ),
                        if (totalAll > 0) ...[
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 6,
                              backgroundColor: const Color(0xFFF1F5F9),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppTheme.brandPrimary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 2. Topic List Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_exercises.length} CHỦ ĐỀ LUYỆN TẬP',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF64748B),
                          letterSpacing: 0.6,
                        ),
                      ),
                      const Text(
                        'Chạm chủ đề để bắt đầu',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 3. Exercises List
                  if (_exercises.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.brandBorder),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.inbox_rounded, size: 36, color: Color(0xFF94A3B8)),
                          SizedBox(height: 8),
                          Text(
                            'Đang cập nhật bài học cho phần này...',
                            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _exercises.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, idx) {
                        final ex = _exercises[idx];
                        final completed = _completedCounts[ex.exerciseId] ?? 0;
                        final totalSentences = ex.sentences.length;

                        return _buildExerciseCard(
                          exercise: ex,
                          index: idx + 1,
                          completedSentences: completed,
                          totalSentences: totalSentences,
                          stepNum: meta.step,
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildExerciseCard({
    required WritingTranslationExercise exercise,
    required int index,
    required int completedSentences,
    required int totalSentences,
    required int stepNum,
  }) {
    final isFullyDone = completedSentences > 0 && completedSentences >= totalSentences;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFullyDone ? const Color(0xFF86EFAC) : AppTheme.brandBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WritingTranslationPracticeScreen(exercise: exercise),
              ),
            );
            // Reload progress when returning from practice
            _loadExercises();
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Index badge
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isFullyDone
                        ? const Color(0xFFDCFCE7)
                        : const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$index',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isFullyDone
                          ? const Color(0xFF16A34A)
                          : AppTheme.brandPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        exercise.title,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.brandTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                stepNum == 5
                                    ? 'BƯỚC 5 • DỊCH ESSAY THEO ĐOẠN'
                                    : 'BƯỚC $stepNum • NHẤN TỪ ĐỂ XEM GỢI Ý',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF475569),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Progress or count indicator
                      Row(
                        children: [
                          Icon(
                            isFullyDone
                                ? Icons.check_circle_rounded
                                : Icons.edit_note_rounded,
                            size: 14,
                            color: isFullyDone
                                ? const Color(0xFF16A34A)
                                : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              completedSentences > 0
                                  ? 'Đã làm $completedSentences / $totalSentences ${stepNum == 5 ? 'đoạn' : 'câu'}'
                                  : '$totalSentences ${stepNum == 5 ? 'đoạn essay' : 'câu dịch'}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: isFullyDone
                                    ? const Color(0xFF16A34A)
                                    : const Color(0xFF64748B),
                                fontWeight: isFullyDone ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Action button chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Thử ngay',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.brandPrimary,
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 14,
                        color: AppTheme.brandPrimary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
