import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../../shared/widgets/app_back_button.dart';
import '../data/writing_translation_repository.dart';
import '../models/writing_translation_model.dart';
import 'writing_translation_practice_screen.dart';

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
  late int _selectedStep;
  bool _isLoading = true;
  List<WritingTranslationExercise> _exercises = [];
  Map<String, int> _completedCounts = {};

  @override
  void initState() {
    super.initState();
    _selectedStep = widget.initialStep.clamp(1, 5);
    _loadStepData(_selectedStep);
  }

  Future<void> _loadStepData(int step) async {
    setState(() {
      _isLoading = true;
      _selectedStep = step;
    });

    final list = await WritingTranslationRepository.instance.getExercisesByStep(step);
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

  WritingTranslationStepMeta get _currentMeta =>
      WritingTranslationStepMeta.allSteps.firstWhere(
        (m) => m.step == _selectedStep,
        orElse: () => WritingTranslationStepMeta.allSteps.first,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const AppBackButton(),
        title: const Text(
          'Luyện Dịch IELTS (Writing)',
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
                borderRadius: BorderRadius.circular(16),
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
                          borderRadius: BorderRadius.circular(6),
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
                    'TẬP DỊCH IELTS SONG NGỮ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Luyện tập chuyển ngữ từ tiếng Việt sang tiếng Anh học thuật giúp bạn làm chủ ngữ pháp, collocations và tư duy viết chuẩn thi.',
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

            // 2. Step Selector Tabs (5 Steps)
            const Text(
              'LỘ TRÌNH 5 BƯỚC',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF64748B),
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 8),

            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: WritingTranslationStepMeta.allSteps.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  final meta = WritingTranslationStepMeta.allSteps[idx];
                  final isSelected = meta.step == _selectedStep;

                  return InkWell(
                    onTap: () {
                      if (_selectedStep != meta.step) {
                        _loadStepData(meta.step);
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.brandPrimary : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.brandPrimary
                              : const Color(0xFFCBD5E1),
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppTheme.brandPrimary.withValues(alpha: 0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withValues(alpha: 0.25)
                                  : const Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${meta.step}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : const Color(0xFF475569),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Bước ${meta.step}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              color: isSelected ? Colors.white : const Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),

            // 3. Active Step Details Info Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.auto_stories_rounded,
                      color: AppTheme.brandPrimary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              _currentMeta.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.brandTextPrimary,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _currentMeta.subtitle,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF15803D),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _currentMeta.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 4. Topic List Header
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
                if (!_isLoading)
                  Text(
                    '${_exercises.fold<int>(0, (acc, e) => acc + e.sentences.length)} câu song ngữ',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.brandPrimary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // 5. Exercise Cards List
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_exercises.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.inbox_rounded, size: 36, color: Color(0xFF94A3B8)),
                    SizedBox(height: 8),
                    Text(
                      'Đang cập nhật bài học cho bước này...',
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
  }) {
    final isFullyDone = completedSentences > 0 && completedSentences >= totalSentences;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isFullyDone ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
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
          borderRadius: BorderRadius.circular(14),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WritingTranslationPracticeScreen(exercise: exercise),
              ),
            );
            // Reload progress when returning
            _loadStepData(_selectedStep);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Index badge
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isFullyDone
                        ? const Color(0xFFDCFCE7)
                        : const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$index',
                    style: TextStyle(
                      fontSize: 15,
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
                    children: [
                      Text(
                        exercise.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.brandTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'BƯỚC $_selectedStep • NHẤN TỪ ĐỂ XEM GỢI Ý',
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

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
                          Text(
                            completedSentences > 0
                                ? 'Đã làm $completedSentences / $totalSentences câu'
                                : '$totalSentences câu dịch',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isFullyDone
                                  ? const Color(0xFF16A34A)
                                  : const Color(0xFF64748B),
                              fontWeight: isFullyDone ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Action button chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
