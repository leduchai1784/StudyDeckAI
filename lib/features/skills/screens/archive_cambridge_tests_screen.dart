import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../models/archive_model.dart';
import '../models/listening_test_model.dart';
import '../data/listening_mock_data.dart';
import 'listening_test_screen.dart';
import 'archive_lessons_list_screen.dart';

class ArchiveCambridgeTestsScreen extends StatelessWidget {
  final ArchiveGroup group;

  const ArchiveCambridgeTestsScreen({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppTheme.brandTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          group.title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppTheme.brandTextPrimary,
            letterSpacing: -0.2,
          ),
        ),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Text(
              '${group.subSections.length} Bài Test',
              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner giới thiệu tập Cambridge
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 52,
                    decoration: BoxDecoration(
                      color: group.tagBgColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: group.tagTextColor.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'IELTS',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: group.tagTextColor.withValues(alpha: 0.8),
                          ),
                        ),
                        Text(
                          group.tagNumber,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: group.tagTextColor,
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
                              group.title,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.brandTextPrimary),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'ACTIVE',
                                style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Gồm 4 bài Test chuẩn format thi thật. Bạn có thể chọn thi toàn bộ đề hoặc luyện riêng từng Part.',
                          style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B), height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Header danh sách Test
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CHỌN BÀI TEST ĐỂ LUYỆN TẬP',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandTextSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  '4 Parts / Test',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Danh sách các Test cards
            ...group.subSections.map((testSub) => _buildTestCard(context, testSub)),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Card cho từng Test trong tập Cambridge
  Widget _buildTestCard(BuildContext context, ArchiveSubSection testSub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header hàng trên: Tên Test & Badge
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.assignment_outlined, color: Color(0xFF2563EB), size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        testSub.subTitle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.brandTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${testSub.questionCount} câu hỏi · ${testSub.durationMinutes} phút · ${testSub.lessons.length} Parts',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(height: 1, color: const Color(0xFFF1F5F9)),
            const SizedBox(height: 12),

            // 2 Nút hành động cốt lõi:
            // 1. [Thi Cả Đề (30p)] -> Làm luôn, giảm màn đi!
            // 2. [Luyện Theo Part (4 Parts) >] -> Chuyển sang màn chi tiết các Part!
            Row(
              children: [
                // Nút [Thi Cả Đề (30p)]
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ListeningTest matchedTest;
                      try {
                        matchedTest = ListeningMockData.allTests.firstWhere((t) => t.id == testSub.testId);
                      } catch (_) {
                        matchedTest = ListeningMockData.allTests.first;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListeningTestScreen(
                            test: matchedTest,
                            isRealTest: true,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.timer_outlined, size: 16),
                    label: const Text('Thi cả đề (30p)'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2563EB),
                      side: const BorderSide(color: Color(0xFFBFDBFE)),
                      backgroundColor: const Color(0xFFEFF6FF),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Nút [Luyện 4 Parts >]
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArchiveLessonsListScreen(
                            title: '${group.title} — ${testSub.subTitle}',
                            subtitle: '${testSub.lessons.length} Parts Listening',
                            lessons: testSub.lessons,
                            testId: testSub.testId,
                            isCambridgeTest: true,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.layers_outlined, size: 16),
                    label: const Text('Luyện 4 Parts'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
