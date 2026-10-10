import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../../shared/widgets/app_back_button.dart';
import '../models/listening_test_model.dart';
import 'listening_test_screen.dart';

class CambridgeTestsListScreen extends StatelessWidget {
  final int volume;
  final List<ListeningTest> tests;

  const CambridgeTestsListScreen({
    super.key,
    required this.volume,
    required this.tests,
  });

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

  String _formatSubtitle(ListeningTest test) {
    switch (test.id) {
      case 'cam10_test1':
        return 'Part 1 - 4 • Du lịch California & CLB Thể thao LP';
      case 'cam10_test2':
        return 'Part 1 - 4 • Khảo sát giao thông & Thám hiểm Heyerdahl';
      case 'cam10_test3':
        return 'Part 1 - 4 • Nhà trẻ Early Learning & Bảo tồn cá heo';
      case 'cam10_test4':
        return 'Part 1 - 4 • Xây dựng Thorndyke & Công nghệ Nano';
      case 'cam11_test1':
        return 'Part 1 - 4 • Thuê hội trường Moonfleet & Nông trại Fiddy';
      case 'cam11_test2':
        return 'Part 1 - 4 • Hội đồng thanh niên & Thực địa Rocky Bay';
      case 'cam11_test3':
        return 'Part 1 - 4 • Hoạt động Burnham & Thị trấn Barford';
      case 'cam11_test4':
        return 'Part 1 - 4 • Lễ hội mùa hè & Giảm thiểu CO₂ trong đất';
      case 'cam20_test1':
        return 'Part 1 - 4 • Gợi ý nhà hàng & Xưởng gốm Adelman';
      default:
        return test.subtitle.isNotEmpty ? test.subtitle : 'Part 1 - 4 • Đầy đủ 40 câu hỏi tiêu chuẩn';
    }
  }

  String _getViewCount(ListeningTest test) {
    switch (test.id) {
      case 'cam10_test1':
        return '45.1k lượt làm';
      case 'cam10_test2':
        return '45.2k lượt làm';
      case 'cam10_test3':
        return '45.3k lượt làm';
      case 'cam10_test4':
        return '45.4k lượt làm';
      case 'cam11_test1':
        return '46.1k lượt làm';
      case 'cam11_test2':
        return '46.2k lượt làm';
      case 'cam11_test3':
        return '46.3k lượt làm';
      case 'cam11_test4':
        return '46.4k lượt làm';
      case 'cam20_test1':
        return '54.8k lượt làm';
      default:
        return '43.5k lượt làm';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _getVolumeColor(volume);
    final themeBg = _getVolumeBgColor(volume);
    final totalQuestions = tests.fold<int>(0, (sum, t) => sum + t.totalQuestions);

    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const AppBackButton(),
        title: Text(
          'Cambridge IELTS $volume',
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
                Icon(Icons.assignment_outlined, size: 14, color: themeColor),
                const SizedBox(width: 5),
                Text(
                  '${tests.length} Bài Test',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner giới thiệu bộ đề
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
                    width: 52,
                    height: 56,
                    decoration: BoxDecoration(
                      color: themeBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: themeColor.withValues(alpha: 0.25)),
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
                          '$volume',
                          style: TextStyle(
                            fontSize: 20,
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
                              'Cambridge IELTS $volume',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.brandTextPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'CHÍNH THỨC',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF166534),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${tests.length} bài test • $totalQuestions câu hỏi chuẩn format đề thi thật. Chọn chế độ làm bài phù hợp.',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            height: 1.3,
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
                      Icons.headphones_rounded,
                      size: 18,
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
                  '${tests.length} đề khả dụng',
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
            ...tests.map((test) => _buildTestCard(context, test)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTestCard(BuildContext context, ListeningTest test) {
    final formattedSubtitle = _formatSubtitle(test);
    final viewCount = _getViewCount(test);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
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
          // Header: Tags & View stats
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
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  test.bandTarget,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.volume_up_outlined, size: 14, color: Color(0xFF64748B)),
              const SizedBox(width: 4),
              Text(
                viewCount,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Title
          Text(
            test.title,
            style: const TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              color: AppTheme.brandTextPrimary,
            ),
          ),
          const SizedBox(height: 4),

          // Subtitle
          Text(
            formattedSubtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 14),

          // 2 Nút bấm hành động: [Luyện tập] & [Thi thật (30p)]
          Row(
            children: [
              // Nút 1: Luyện tập (Outlined)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListeningTestScreen(
                          test: test,
                          isRealTest: false,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.format_list_bulleted_rounded,
                    size: 16,
                    color: AppTheme.brandPrimary,
                  ),
                  label: const Text(
                    'Luyện tập',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppTheme.brandPrimary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    backgroundColor: const Color(0xFFF8FAFC),
                    side: const BorderSide(color: Color(0xFFC7D2FE), width: 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Nút 2: Thi thật (30p)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListeningTestScreen(
                          test: test,
                          isRealTest: true,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.access_time_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Thi thật (30p)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.brandPrimary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
