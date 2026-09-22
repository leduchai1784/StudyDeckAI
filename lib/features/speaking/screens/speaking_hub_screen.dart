import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../skills/screens/dictation_library_screen.dart';
import 'speaking_forecast_screen.dart';
import 'speaking_roulette_screen.dart';
import 'speaking_practice_screen.dart';
import '../data/speaking_mock_data.dart';

class SpeakingHubScreen extends StatelessWidget {
  const SpeakingHubScreen({super.key});

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
          'IELTS Speaking Lab',
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

            // 2. Bento Grid Item 1: Forecast Speaking
            _buildBentoCard(
              context: context,
              icon: Icons.auto_awesome_rounded,
              iconBgColor: const Color(0xFFFEE2E2),
              iconColor: const Color(0xFFDC2626),
              badgeText: 'DỰ ĐOÁN QUÝ 3/2026',
              badgeBgColor: const Color(0xFFFEF2F2),
              badgeTextColor: const Color(0xFFB91C1C),
              title: 'Bộ Đề Dự Đoán',
              subtitle: 'Ngân hàng câu hỏi thi thật Quý 3 & Quý 2 phân loại Part 1, 2, 3.',
              footerInfo: 'Gợi ý dàn ý A.R.E.A',
              buttonLabel: 'Luyện đề',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SpeakingForecastScreen()),
                );
              },
            ),
            const SizedBox(height: 14),

            // 3. Bento Grid Item 2: Speaking Roulette 3D
            _buildBentoCard(
              context: context,
              icon: Icons.style_rounded,
              iconBgColor: const Color(0xFFEEF2FF),
              iconColor: const Color(0xFF4F46E5),
              badgeText: 'PHẢN XẠ NHANH',
              badgeBgColor: const Color(0xFFEEF2FF),
              badgeTextColor: const Color(0xFF4338CA),
              title: 'Vòng Quay Bốc Bài',
              subtitle: 'Rút thẻ câu hỏi ngẫu nhiên và tra từ vựng ngữ cảnh tức thì.',
              footerInfo: 'Thẻ bài 3D ngẫu nhiên',
              buttonLabel: 'Bốc thẻ',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SpeakingRouletteScreen()),
                );
              },
            ),
            const SizedBox(height: 14),

            // 4. Bento Grid Item 3: Giám Khảo AI Mock Interview
            _buildBentoCard(
              context: context,
              icon: Icons.psychology_rounded,
              iconBgColor: const Color(0xFFECFDF5),
              iconColor: const Color(0xFF059669),
              badgeText: 'GIÁM KHẢO AI',
              badgeBgColor: const Color(0xFFDCFCE7),
              badgeTextColor: const Color(0xFF15803D),
              title: 'Phòng Thi Giám Khảo AI',
              subtitle: 'Phỏng vấn trực tiếp và chấm điểm 4 tiêu chí chuẩn IELTS.',
              footerInfo: 'Chấm 4 tiêu chí Band 9.0',
              buttonLabel: 'Vào thi',
              onTap: () {
                final sampleTopic = SpeakingMockData.forecastTopics.first;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpeakingPracticeScreen(
                      topic: sampleTopic,
                      initialQuestionIndex: 0,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),

            // 5. Bento Grid Item 4: Shadowing & Lồng Tiếng Hub
            _buildBentoCard(
              context: context,
              icon: Icons.record_voice_over_rounded,
              iconBgColor: const Color(0xFFFFFBEB),
              iconColor: const Color(0xFFD97706),
              badgeText: 'LUYỆN NGỮ ĐIỆU',
              badgeBgColor: const Color(0xFFFEF3C7),
              badgeTextColor: const Color(0xFF92400E),
              title: 'Luyện Ngữ Điệu Shadowing',
              subtitle: 'Luyện nhại giọng người bản xứ và ngắt nghỉ tự nhiên.',
              footerInfo: 'IELTS & TED-Ed',
              buttonLabel: 'Luyện tập',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DictationLibraryScreen()),
                );
              },
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  // Bento Card Component
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
