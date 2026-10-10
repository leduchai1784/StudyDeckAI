import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../shared/widgets/app_back_button.dart';
import '../models/reading_test_model.dart';
import '../models/reading_result_model.dart';
import '../services/reading_progress_service.dart';

class CambridgeReadingTestsScreen extends StatefulWidget {
  final int volume;
  final List<ReadingTest> tests;

  const CambridgeReadingTestsScreen({
    super.key,
    required this.volume,
    required this.tests,
  });

  @override
  State<CambridgeReadingTestsScreen> createState() =>
      _CambridgeReadingTestsScreenState();
}

class _CambridgeReadingTestsScreenState
    extends State<CambridgeReadingTestsScreen> {
  final ReadingProgressService _progressService = ReadingProgressService();
  Map<String, ReadingTestResult> _resultsMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    final allResults = await _progressService.getAllResults();
    final Map<String, ReadingTestResult> map = {};
    for (final r in allResults) {
      map[r.testId] = r;
    }
    if (mounted) {
      setState(() {
        _resultsMap = map;
        _isLoading = false;
      });
    }
  }

  Color _getVolumeColor(int vol) {
    switch (vol % 6) {
      case 0:
        return const Color(0xFF4F46E5); // Indigo
      case 1:
        return const Color(0xFF0D9488); // Teal
      case 2:
        return const Color(0xFF2563EB); // Blue
      case 3:
        return const Color(0xFF7C3AED); // Purple
      case 4:
        return const Color(0xFFD97706); // Amber
      case 5:
      default:
        return const Color(0xFFE11D48); // Rose
    }
  }

  Color _getVolumeBgColor(int vol) {
    switch (vol % 6) {
      case 0:
        return const Color(0xFFEEF2FF);
      case 1:
        return const Color(0xFFF0FDFA);
      case 2:
        return const Color(0xFFEFF6FF);
      case 3:
        return const Color(0xFFF5F3FF);
      case 4:
        return const Color(0xFFFFFBEB);
      case 5:
      default:
        return const Color(0xFFFFF1F2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _getVolumeColor(widget.volume);
    final themeBg = _getVolumeBgColor(widget.volume);
    final totalQuestions =
        widget.tests.fold<int>(0, (sum, t) => sum + t.totalQuestions);

    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const AppBackButton(),
        title: Text(
          'Cambridge IELTS ${widget.volume}',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppTheme.brandTextPrimary,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: themeBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: themeColor.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.menu_book_rounded, size: 14, color: themeColor),
                const SizedBox(width: 5),
                Text(
                  '${widget.tests.length} Bài Test',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.brandPrimary),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner giới thiệu bộ đề Reading
                  Container(
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
                    child: Row(
                      children: [
                        Container(
                          width: 54,
                          height: 58,
                          decoration: BoxDecoration(
                            color: themeBg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: themeColor.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'CAM',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  color: themeColor.withValues(alpha: 0.8),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                '${widget.volume}',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w900,
                                  color: themeColor,
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Cambridge IELTS ${widget.volume}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.brandTextPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: widget.volume >= 20
                                          ? const Color(0xFFFEF3C7)
                                          : const Color(0xFFDCFCE7),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      widget.volume >= 20
                                          ? 'MỚI NHẤT'
                                          : 'CHÍNH THỨC',
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.bold,
                                        color: widget.volume >= 20
                                            ? const Color(0xFFB45309)
                                            : const Color(0xFF166534),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.tests.length} bài test • $totalQuestions câu hỏi Academic chuẩn Cambridge. Thời gian 60 phút/đề.',
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
                  const SizedBox(height: 20),

                  // Header danh sách đề thi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.menu_book_rounded,
                            size: 17,
                            color: AppTheme.brandPrimary,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'CÁC BÀI TEST TRONG BỘ',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF475569),
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${widget.tests.length} đề khả dụng',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Danh sách các bài test
                  ...widget.tests.map((test) => _buildTestCard(test)),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildTestCard(ReadingTest test) {
    final result = _resultsMap[test.id];
    final bool isCompleted = result != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isCompleted ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
          width: isCompleted ? 1.4 : 1.0,
        ),
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
          // Header badges
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8F0),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'THI THẬT',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF059669),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.tintIndigoBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  test.bookSeries.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  test.bandTarget,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
              const Spacer(),
              if (isCompleted)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 13,
                        color: Color(0xFF16A34A),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Band ${result.bandScore.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Title
          Text(
            test.title,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.bold,
              color: AppTheme.brandTextPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // Passages preview
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(test.passages.length, (pIdx) {
              final p = test.passages[pIdx];
              return Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(
                  children: [
                    Text(
                      'Part ${p.partNumber}: ',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        p.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          // Bottom Stats & Action Button
          Row(
            children: [
              const Icon(Icons.help_outline_rounded,
                  size: 14, color: Color(0xFF94A3B8)),
              const SizedBox(width: 4),
              Text(
                '${test.totalQuestions} câu',
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.timer_outlined,
                  size: 14, color: Color(0xFF94A3B8)),
              const SizedBox(width: 4),
              Text(
                '${test.durationMinutes} phút',
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () async {
                  await context.push(
                    '/reading/practice',
                    extra: {'test': test},
                  );
                  _loadResults();
                },
                icon: Icon(
                  isCompleted
                      ? Icons.refresh_rounded
                      : Icons.play_arrow_rounded,
                  size: 16,
                ),
                label: Text(isCompleted ? 'Làm lại' : 'Làm bài ngay'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.brandPrimary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
