import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../data/reading_mock_data.dart';
import '../models/reading_test_model.dart';
import '../models/reading_result_model.dart';
import '../services/reading_progress_service.dart';
import '../../../../shared/widgets/app_back_button.dart';
import 'cambridge_reading_tests_screen.dart';

class ReadingHubScreen extends StatefulWidget {
  const ReadingHubScreen({super.key});

  @override
  State<ReadingHubScreen> createState() => _ReadingHubScreenState();
}

class _ReadingHubScreenState extends State<ReadingHubScreen> {
  final ReadingProgressService _progressService = ReadingProgressService();

  String _searchQuery = '';
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
    const allTests = ReadingMockData.allTests;

    // Gom nhóm các bài test theo từng tập Cambridge (14 đến 20)
    final Map<int, List<ReadingTest>> cambridgeVolumes = {};
    for (final test in allTests) {
      final m = RegExp(r'(\d+)').firstMatch(test.bookSeries) ??
          RegExp(r'cam(\d+)').firstMatch(test.id);
      if (m != null) {
        final vol = int.parse(m.group(1)!);
        cambridgeVolumes.putIfAbsent(vol, () => []).add(test);
      }
    }
    // Sắp xếp thứ tự mới nhất lên đầu: Cam 20, Cam 19, Cam 18, Cam 15, Cam 14
    final sortedVolumes = cambridgeVolumes.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    // Tìm kiếm nếu người dùng nhập query
    List<ReadingTest> searchResults = [];
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      searchResults = allTests.where((t) {
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
        leading: const AppBackButton(),
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
              border: Border.all(
                  color: AppTheme.brandPrimary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.menu_book_rounded,
                    size: 14, color: AppTheme.brandPrimary),
                const SizedBox(width: 5),
                Text(
                  '${allTests.length} Đề • ${sortedVolumes.length} Bộ Cam',
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
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.brandPrimary),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Search Bar
                  TextField(
                    onChanged: (val) =>
                        setState(() => _searchQuery = val.trim()),
                    decoration: InputDecoration(
                      hintText:
                          'Tìm kiếm đề Reading (Cam 20, Nutmeg, AI...)...',
                      hintStyle: const TextStyle(
                          fontSize: 13, color: Color(0xFF94A3B8)),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: Color(0xFF94A3B8), size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded,
                                  size: 18, color: Color(0xFF94A3B8)),
                              onPressed: () =>
                                  setState(() => _searchQuery = ''),
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
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
                        borderSide:
                            const BorderSide(color: AppTheme.brandPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Chế độ hiển thị: Khi đang tìm kiếm vs Khi xem danh sách các bộ Cambridge
                  if (_searchQuery.isNotEmpty) ...[
                    // Kết quả tìm kiếm
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.search_rounded,
                                size: 16, color: AppTheme.brandPrimary),
                            SizedBox(width: 6),
                            Text(
                              'KẾT QUẢ TÌM KIẾM',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF475569),
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${searchResults.length} đề phù hợp',
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (searchResults.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(32),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            const Icon(Icons.search_off_rounded,
                                size: 44, color: Color(0xFF94A3B8)),
                            const SizedBox(height: 10),
                            Text(
                              'Không tìm thấy đề thi phù hợp với "$_searchQuery"',
                              style: const TextStyle(
                                  fontSize: 13.5, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: searchResults.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final test = searchResults[index];
                          final result = _resultsMap[test.id];
                          return _buildTestCard(test, result);
                        },
                      ),
                  ] else ...[
                    // Màn hình chính: Banner tổng quan
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
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppTheme.tintIndigoBg,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppTheme.brandPrimary
                                      .withValues(alpha: 0.2)),
                            ),
                            child: const Icon(
                              Icons.auto_stories_rounded,
                              color: AppTheme.brandPrimary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ngân hàng Đề Cambridge Reading',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.brandTextPrimary,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Chọn từng bộ sách Cambridge bên dưới để xem danh sách các đề thi và bắt đầu luyện tập.',
                                  style: TextStyle(
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

                    // Section Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Text(
                              '📖',
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'ĐỀ THI CAMBRIDGE',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF475569),
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${allTests.length} Đề • ${sortedVolumes.length} Bộ (Cam 14 – 20)',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Danh sách các bộ sách Cambridge (Ấn vào từng bộ để xem đề)
                    ...sortedVolumes.map((vol) {
                      final tests = cambridgeVolumes[vol] ?? [];
                      return _buildCambridgeBookCard(vol, tests);
                    }),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  // Card hiển thị từng bộ sách Cambridge ở màn hình ngoài
  Widget _buildCambridgeBookCard(int volume, List<ReadingTest> tests) {
    final color = _getVolumeColor(volume);
    final bgColor = _getVolumeBgColor(volume);
    final totalQuestions =
        tests.fold<int>(0, (sum, t) => sum + t.totalQuestions);

    int completedCount = 0;
    for (final t in tests) {
      if (_resultsMap.containsKey(t.id)) {
        completedCount++;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: completedCount > 0
              ? const Color(0xFF86EFAC)
              : const Color(0xFFE2E8F0),
          width: completedCount > 0 ? 1.2 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CambridgeReadingTestsScreen(
                  volume: volume,
                  tests: tests,
                ),
              ),
            );
            _loadResults();
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                // Khối vuông CAM $volume
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: color.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'CAM',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: color.withValues(alpha: 0.8),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        '$volume',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: color,
                          height: 1.05,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),

                // Tiêu đề & Thông tin bộ sách
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Cambridge IELTS $volume',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.brandTextPrimary,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: volume >= 20
                                  ? const Color(0xFFFEF3C7)
                                  : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              volume >= 20 ? 'MỚI NHẤT' : 'CHÍNH THỨC',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: volume >= 20
                                    ? const Color(0xFFB45309)
                                    : const Color(0xFF475569),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${tests.length} đề thi Academic • $totalQuestions câu hỏi',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 5),
                      if (completedCount > 0)
                        Row(
                          children: [
                            const Icon(Icons.check_circle_rounded,
                                size: 13, color: Color(0xFF16A34A)),
                            const SizedBox(width: 4),
                            Text(
                              'Đã làm $completedCount/${tests.length} đề',
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF15803D),
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          tests.isNotEmpty
                              ? tests.first.bandTarget
                              : 'Band 6.5 - 7.5',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Card hiển thị bài test khi tìm kiếm
  Widget _buildTestCard(ReadingTest test, ReadingTestResult? result) {
    final bool isCompleted = result != null;

    return Container(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          size: 13, color: Color(0xFF16A34A)),
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
          Text(
            test.title,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.bold,
              color: AppTheme.brandTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
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
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
