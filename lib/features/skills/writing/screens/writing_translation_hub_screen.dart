import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../../shared/widgets/app_back_button.dart';
import '../data/writing_translation_repository.dart';
import '../models/writing_translation_model.dart';
import 'writing_translation_topics_screen.dart';

class WritingTranslationHubScreen extends StatefulWidget {
  final int initialStep;

  const WritingTranslationHubScreen({
    super.key,
    this.initialStep = 1,
  });

  @override
  State<WritingTranslationHubScreen> createState() =>
      _WritingTranslationHubScreenState();
}

class _WritingTranslationHubScreenState
    extends State<WritingTranslationHubScreen> {
  final Map<int, int> _completedCounts = {};
  final Map<int, int> _totalCounts = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final comp = <int, int>{};
    final tot = <int, int>{};

    for (final meta in WritingTranslationStepMeta.allSteps) {
      final list = await WritingTranslationRepository.instance
          .getExercisesByStep(meta.step);
      int done = 0;
      int total = 0;
      for (final ex in list) {
        total += ex.sentences.length;
        final c = await WritingTranslationRepository.instance
            .getCompletedCountForExercise(ex.exerciseId);
        done += c;
      }
      comp[meta.step] = done;
      tot[meta.step] = total;
    }

    if (mounted) {
      setState(() {
        _completedCounts.addAll(comp);
        _totalCounts.addAll(tot);
      });
    }
  }

  // Visual styling for each step
  Map<String, dynamic> _getStepStyle(int step) {
    switch (step) {
      case 1:
        return {
          'icon': Icons.format_shapes_rounded,
          'color': const Color(0xFF4F46E5),
          'bg': const Color(0xFFEEF2FF),
          'badgeBg': const Color(0xFFEEF2FF),
          'badgeColor': const Color(0xFF4F46E5),
        };
      case 2:
        return {
          'icon': Icons.auto_awesome_rounded,
          'color': const Color(0xFF059669),
          'bg': const Color(0xFFDCFCE7),
          'badgeBg': const Color(0xFFDCFCE7),
          'badgeColor': const Color(0xFF15803D),
        };
      case 3:
        return {
          'icon': Icons.view_agenda_rounded,
          'color': const Color(0xFFD97706),
          'bg': const Color(0xFFFEF3C7),
          'badgeBg': const Color(0xFFFEF3C7),
          'badgeColor': const Color(0xFFB45309),
        };
      case 4:
        return {
          'icon': Icons.trending_up_rounded,
          'color': const Color(0xFF7C3AED),
          'bg': const Color(0xFFF3E8FF),
          'badgeBg': const Color(0xFFF3E8FF),
          'badgeColor': const Color(0xFF6D28D9),
        };
      case 5:
      default:
        return {
          'icon': Icons.school_rounded,
          'color': const Color(0xFFDC2626),
          'bg': const Color(0xFFFEE2E2),
          'badgeBg': const Color(0xFFFEE2F2),
          'badgeColor': const Color(0xFFBE123C),
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const AppBackButton(),
        title: const Text(
          'Luyện Dịch IELTS (Song Ngữ)',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
            color: AppTheme.brandTextPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hub Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF312E81), Color(0xFF4338CA), Color(0xFF6366F1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4338CA).withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
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
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'TRANSLATION HUB',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.translate_rounded, color: Colors.white70, size: 22),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'LỘ TRÌNH 5 BƯỚC LUYỆN DỊCH',
                    style: TextStyle(
                      fontSize: 17.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Rèn tư duy chuyển ngữ từ câu đơn S-V-O đến bài luận IELTS Task 2 hoàn chỉnh. Chọn từng phần để vào luyện tập.',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFFE0E7FF),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 2. Section Header
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '5 PHẦN LUYỆN DỊCH',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.6,
                  ),
                ),
                Text(
                  '51 chủ đề • 1.700+ câu',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.brandPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 3. Step Cards List (Tap to open exercises for that step)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: WritingTranslationStepMeta.allSteps.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final meta = WritingTranslationStepMeta.allSteps[idx];
                final style = _getStepStyle(meta.step);
                final done = _completedCounts[meta.step] ?? 0;
                final total = _totalCounts[meta.step] ?? (meta.step == 1 ? 200 : (meta.step == 2 ? 675 : (meta.step == 3 ? 525 : (meta.step == 4 ? 243 : 70))));
                final isCompleted = done > 0 && done >= total;

                return _buildStepCard(
                  meta: meta,
                  style: style,
                  doneCount: done,
                  totalCount: total,
                  isCompleted: isCompleted,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard({
    required WritingTranslationStepMeta meta,
    required Map<String, dynamic> style,
    required int doneCount,
    required int totalCount,
    required bool isCompleted,
  }) {
    final IconData icon = style['icon'] as IconData;
    final Color color = style['color'] as Color;
    final Color bg = style['bg'] as Color;
    final Color badgeBg = style['badgeBg'] as Color;
    final Color badgeColor = style['badgeColor'] as Color;
    final double progress = totalCount > 0 ? (doneCount / totalCount).clamp(0.0, 1.0) : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted ? const Color(0xFF86EFAC) : AppTheme.brandBorder,
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
                builder: (context) => WritingTranslationTopicsScreen(
                  stepMeta: meta,
                ),
              ),
            );
            // Reload progress when returning to hub
            _loadProgress();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Icon Box + Badges & Stats
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Step Number Icon Box
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: color, size: 22),
                    ),
                    const SizedBox(width: 12),

                    // Title & Badge
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                                decoration: BoxDecoration(
                                  color: badgeBg,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  meta.badge.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: badgeColor,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                meta.subtitle,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            meta.title,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.brandTextPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Description (Short 1-line)
                Text(
                  meta.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF64748B),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),

                // Bottom Row: Progress info & CTA Button
                Row(
                  children: [
                    // Progress text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isCompleted
                                    ? Icons.check_circle_rounded
                                    : Icons.edit_note_rounded,
                                size: 14,
                                color: isCompleted
                                    ? const Color(0xFF16A34A)
                                    : const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                doneCount > 0
                                    ? 'Đã học $doneCount / $totalCount ${meta.step == 5 ? 'đoạn' : 'câu'}'
                                    : '$totalCount ${meta.step == 5 ? 'đoạn essay' : 'câu dịch'}',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: doneCount > 0 ? FontWeight.bold : FontWeight.normal,
                                  color: isCompleted
                                      ? const Color(0xFF16A34A)
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          if (totalCount > 0) ...[
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 4,
                                backgroundColor: const Color(0xFFF1F5F9),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isCompleted ? const Color(0xFF16A34A) : color,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Action Button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: isCompleted ? const Color(0xFFDCFCE7) : bg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isCompleted ? 'Ôn lại' : 'Vào học',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isCompleted ? const Color(0xFF15803D) : color,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 15,
                            color: isCompleted ? const Color(0xFF15803D) : color,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
