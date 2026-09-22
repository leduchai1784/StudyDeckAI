import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../data/reading_mock_data.dart';
import '../models/reading_test_model.dart';
import '../models/reading_result_model.dart';
import '../services/reading_progress_service.dart';

class ReadingHubScreen extends StatefulWidget {
  const ReadingHubScreen({super.key});

  @override
  State<ReadingHubScreen> createState() => _ReadingHubScreenState();
}

class _ReadingHubScreenState extends State<ReadingHubScreen> {
  final ReadingProgressService _progressService = ReadingProgressService();

  int _selectedFilterIndex = 0;
  String _searchQuery = '';
  Map<String, ReadingTestResult> _resultsMap = {};
  bool _isLoading = true;

  final List<String> _filters = [
    'Tất cả đề',
    'Cambridge 20',
    'Cambridge 19',
    'Cambridge 18',
    'Band 6.0 - 7.0',
    'Band 7.0+',
  ];

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

  @override
  Widget build(BuildContext context) {
    const allTests = ReadingMockData.allTests;
    List<ReadingTest> displayedTests = allTests;

    // Filter by series or band
    if (_selectedFilterIndex == 1) {
      displayedTests = allTests.where((t) => t.bookSeries.contains('20')).toList();
    } else if (_selectedFilterIndex == 2) {
      displayedTests = allTests.where((t) => t.bookSeries.contains('19')).toList();
    } else if (_selectedFilterIndex == 3) {
      displayedTests = allTests.where((t) => t.bookSeries.contains('18')).toList();
    } else if (_selectedFilterIndex == 4) {
      displayedTests = allTests.where((t) => t.bandTarget.contains('6.0') || t.bandTarget.contains('6.5')).toList();
    } else if (_selectedFilterIndex == 5) {
      displayedTests = allTests.where((t) => t.bandTarget.contains('7.0') || t.bandTarget.contains('7.5') || t.bandTarget.contains('8.0')).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      displayedTests = displayedTests.where((t) {
        if (t.title.toLowerCase().contains(q)) return true;
        if (t.bookSeries.toLowerCase().contains(q)) return true;
        for (final p in t.passages) {
          if (p.title.toLowerCase().contains(q)) return true;
        }
        return false;
      }).toList();
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
        title: const Text(
          'Luyện Đọc IELTS Reading',
          style: TextStyle(
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
              color: AppTheme.tintIndigoBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.brandPrimary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.menu_book_rounded, size: 14, color: AppTheme.brandPrimary),
                const SizedBox(width: 5),
                Text(
                  '${allTests.length} Đề Cam',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.brandPrimary))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Search Bar
                  TextField(
                    onChanged: (val) => setState(() => _searchQuery = val.trim()),
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm đề Reading (Cam 20, Manhattan, AI...)...',
                      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                      prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 20),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppTheme.brandPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 2. Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_filters.length, (idx) {
                        final isSelected = _selectedFilterIndex == idx;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(_filters[idx]),
                            selected: isSelected,
                            onSelected: (_) => setState(() => _selectedFilterIndex = idx),
                            selectedColor: AppTheme.brandPrimary,
                            backgroundColor: Colors.white,
                            labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.white : const Color(0xFF475569),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: isSelected ? AppTheme.brandPrimary : const Color(0xFFE2E8F0),
                              ),
                            ),
                            showCheckmark: false,
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. Section Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'NGÂN HÀNG ĐỀ THI CAMBRIDGE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.brandTextSecondary,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Text(
                        '${displayedTests.length} đề',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 4. Test Cards
                  if (displayedTests.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const Icon(Icons.search_off_rounded, size: 44, color: Color(0xFF94A3B8)),
                          const SizedBox(height: 10),
                          Text(
                            'Không tìm thấy đề thi phù hợp với "$_searchQuery"',
                            style: const TextStyle(fontSize: 13.5, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: displayedTests.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final test = displayedTests[index];
                        final result = _resultsMap[test.id];
                        return _buildTestCard(test, result);
                      },
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildTestCard(ReadingTest test, ReadingTestResult? result) {
    final bool isCompleted = result != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
          width: isCompleted ? 1.4 : 1.0,
        ),
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
          // Top Row: Series Badge + Band Score if done
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.tintIndigoBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  test.bookSeries.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  test.bandTarget,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
              const Spacer(),
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 13, color: Color(0xFF16A34A)),
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

          // Bottom Stats & Action
          Row(
            children: [
              const Icon(Icons.help_outline_rounded, size: 14, color: Color(0xFF94A3B8)),
              const SizedBox(width: 4),
              Text(
                '${test.totalQuestions} câu',
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.timer_outlined, size: 14, color: Color(0xFF94A3B8)),
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
                  isCompleted ? Icons.refresh_rounded : Icons.play_arrow_rounded,
                  size: 16,
                ),
                label: Text(isCompleted ? 'Làm lại' : 'Làm bài ngay'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.brandPrimary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
