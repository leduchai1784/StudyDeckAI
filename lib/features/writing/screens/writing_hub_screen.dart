import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../data/writing_mock_data.dart';
import '../models/writing_model.dart';
import 'writing_tests_list_screen.dart';
import 'writing_practice_screen.dart';
import 'writing_translation_screen.dart';

class WritingHubScreen extends StatelessWidget {
  const WritingHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppTheme.brandTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'IELTS Writing Lab',
          style: TextStyle(
            fontSize: 17,
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
            // 1. Section Title
            const Text(
              'CHẾ ĐỘ LUYỆN TẬP',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.brandTextSecondary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 12),

            // 2. Bento Card 1: Kho Đề Thi Viết
            _buildBentoCard(
              context: context,
              icon: Icons.menu_book_rounded,
              iconBgColor: const Color(0xFFFEE2E2),
              iconColor: const Color(0xFFDC2626),
              badgeText: 'TASK 1 & TASK 2',
              badgeBgColor: const Color(0xFFFEF2F2),
              badgeTextColor: const Color(0xFFB91C1C),
              title: 'Kho Đề Thi Viết',
              subtitle: 'Bộ đề thi thật Task 1 và Task 2 phân loại theo từng dạng bài chuẩn Cambridge.',
              footerInfo: 'Đề thi thật • Chấm chữa AI',
              buttonLabel: 'Luyện đề',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WritingTestsListScreen()),
                );
              },
            ),
            const SizedBox(height: 14),

            // 3. Bento Card 2: Luyện Viết Task 2 (Essay)
            _buildBentoCard(
              context: context,
              icon: Icons.edit_note_rounded,
              iconBgColor: const Color(0xFFFFFBEB),
              iconColor: const Color(0xFFD97706),
              badgeText: 'NGHỊ LUẬN XÃ HỘI',
              badgeBgColor: const Color(0xFFFEF3C7),
              badgeTextColor: const Color(0xFF92400E),
              title: 'Phòng Viết Task 2',
              subtitle: 'Luyện viết bài luận tối thiểu 250 từ, gợi ý ý tưởng AI Brainstorm và sửa lỗi tức thì.',
              footerInfo: 'Dàn ý • Chấm 4 tiêu chí',
              buttonLabel: 'Vào viết',
              onTap: () {
                final task2Prompt = WritingMockData.prompts.firstWhere(
                  (p) => p.taskType == WritingTaskType.task2,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WritingPracticeScreen(prompt: task2Prompt),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),

            // 4. Bento Card 3: Luyện Viết Task 1 (Report)
            _buildBentoCard(
              context: context,
              icon: Icons.pie_chart_rounded,
              iconBgColor: const Color(0xFFEEF2FF),
              iconColor: const Color(0xFF4F46E5),
              badgeText: 'MÔ TẢ BIỂU ĐỒ',
              badgeBgColor: const Color(0xFFEEF2FF),
              badgeTextColor: const Color(0xFF4338CA),
              title: 'Phòng Viết Task 1',
              subtitle: 'Mô tả biểu đồ tròn, cột, đường, bảng và bản đồ tối thiểu 150 từ.',
              footerInfo: 'Từ vựng miêu tả số liệu',
              buttonLabel: 'Vào viết',
              onTap: () {
                final task1Prompt = WritingMockData.prompts.firstWhere(
                  (p) => p.taskType == WritingTaskType.task1,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WritingPracticeScreen(prompt: task1Prompt),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),

            // 5. Bento Card 4: Tập Dịch IELTS
            _buildBentoCard(
              context: context,
              icon: Icons.translate_rounded,
              iconBgColor: const Color(0xFFECFDF5),
              iconColor: const Color(0xFF059669),
              badgeText: 'DỊCH VIỆT - ANH',
              badgeBgColor: const Color(0xFFDCFCE7),
              badgeTextColor: const Color(0xFF15803D),
              title: 'Tập Dịch Câu & Collocations',
              subtitle: 'Luyện dịch câu đơn, câu phức và cấu trúc học thuật nâng band ngữ pháp.',
              footerInfo: 'Bước 1 & Bước 2',
              buttonLabel: 'Luyện dịch',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WritingTranslationScreen()),
                );
              },
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildBentoCard({
    required BuildContext context,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String badgeText,
    required Color badgeBgColor,
    required Color badgeTextColor,
    required String title,
    required String subtitle,
    required String footerInfo,
    required String buttonLabel,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Icon & Badge
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: iconColor, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: badgeBgColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badgeText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: badgeTextColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),

                // Subtitle
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF64748B),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 10),

                // Bottom row: Info & Action
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        footerInfo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.brandPrimary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            buttonLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.white),
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
