import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'writing_tests_list_screen.dart';
import 'writing_translation_hub_screen.dart';
import '../../../../shared/widgets/app_back_button.dart';

class WritingHubScreen extends StatelessWidget {
  const WritingHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const AppBackButton(),
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
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

            // Card 1: Luyện Viết IELTS
            _buildBentoCard(
              context: context,
              icon: Icons.edit_note_rounded,
              iconBgColor: const Color(0xFFFEE2E2),
              iconColor: const Color(0xFFDC2626),
              badgeText: 'TASK 1 & TASK 2',
              badgeBgColor: const Color(0xFFFEF2F2),
              badgeTextColor: const Color(0xFFB91C1C),
              title: 'Luyện Viết IELTS',
              subtitle: 'Đề thi thật Cambridge Task 1 & 2, hỗ trợ dàn ý và chấm chữa 4 tiêu chí AI.',
              footerInfo: 'Đề thi thật • Chấm AI',
              buttonLabel: 'Luyện viết',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WritingTestsListScreen()),
                );
              },
            ),
            const SizedBox(height: 14),

            // Card 2: Luyện Dịch IELTS
            _buildBentoCard(
              context: context,
              icon: Icons.translate_rounded,
              iconBgColor: const Color(0xFFECFDF5),
              iconColor: const Color(0xFF059669),
              badgeText: 'DỊCH VIỆT - ANH',
              badgeBgColor: const Color(0xFFDCFCE7),
              badgeTextColor: const Color(0xFF15803D),
              title: 'Luyện Dịch IELTS',
              subtitle: 'Lộ trình 5 bước rèn tư duy câu và từ vựng học thuật từ câu đến bài hoàn chỉnh.',
              footerInfo: '51 Chủ đề • 1.700+ câu',
              buttonLabel: 'Luyện dịch',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WritingTranslationHubScreen()),
                );
              },
            ),
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
        borderRadius: BorderRadius.circular(14),
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
          borderRadius: BorderRadius.circular(14),
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
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandTextPrimary,
                  ),
                ),
                const SizedBox(height: 5),

                // Subtitle
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF64748B),
                    height: 1.4,
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
