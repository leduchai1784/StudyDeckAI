import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'speaking_shadowing_library_screen.dart';
import 'speaking_part1_compulsory_screen.dart';
import 'speaking_part1_topics_screen.dart';
import 'speaking_part2_3_screen.dart';
import 'speaking_roulette_screen.dart';
import 'speaking_practice_screen.dart';
import '../data/speaking_mock_data.dart';
import '../../../../shared/widgets/app_back_button.dart';

class SpeakingHubScreen extends StatelessWidget {
  const SpeakingHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const AppBackButton(),
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Section Title: Kho Đề Thi IELTS
            const Text(
              'KHO ĐỀ THI IELTS (3 PHẦN THI)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.brandTextSecondary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 12),

            // 1. Part 1 Bắt Buộc Tile
            _buildActionTile(
              context: context,
              icon: Icons.push_pin_rounded,
              iconBgColor: const Color(0xFFFEF3C7),
              iconColor: const Color(0xFFD97706),
              title: 'Part 1: Bắt Buộc',
              subtitle: 'Where you live & Work/Study (21 câu)',
              tagText: '2 đề',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SpeakingPart1CompulsoryScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            // 2. Part 2 Chủ Đề Tile
            _buildActionTile(
              context: context,
              icon: Icons.record_voice_over_rounded,
              iconBgColor: const Color(0xFFEFF6FF),
              iconColor: const Color(0xFF2563EB),
              title: 'Part 2: Dự Đoán',
              subtitle: 'Chủ đề thi thật mới nhất (196 câu)',
              tagText: '44 đề',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SpeakingPart1TopicsScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            // 3. Part 3 Tile
            _buildActionTile(
              context: context,
              icon: Icons.timer_outlined,
              iconBgColor: const Color(0xFFEDE9FE),
              iconColor: const Color(0xFF7C3AED),
              title: 'Part 3: Thảo Luận',
              subtitle: 'Cue Card 2 phút & câu hỏi thảo luận',
              tagText: '66 đề',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SpeakingPart23Screen()),
                );
              },
            ),
            const SizedBox(height: 24),

            // 2. Section Title: Chế độ luyện tập
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

            // Action Tiles List
            _buildActionTile(
              context: context,
              icon: Icons.casino_rounded,
              iconBgColor: const Color(0xFFEEF2FF),
              iconColor: const Color(0xFF4F46E5),
              title: 'Vòng Quay Bốc Bài',
              subtitle: 'Rút thẻ ngẫu nhiên, phản xạ tức thì',
              tagText: 'Phản xạ',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SpeakingRouletteScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            _buildActionTile(
              context: context,
              icon: Icons.psychology_rounded,
              iconBgColor: const Color(0xFFECFDF5),
              iconColor: const Color(0xFF059669),
              title: 'Giám Khảo AI',
              subtitle: 'Phỏng vấn 1-1 và chấm 4 tiêu chí',
              tagText: 'Chấm thi',
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
            const SizedBox(height: 12),

            _buildActionTile(
              context: context,
              icon: Icons.graphic_eq_rounded,
              iconBgColor: const Color(0xFFFFFBEB),
              iconColor: const Color(0xFFD97706),
              title: 'Luyện Shadowing',
              subtitle: 'Nhại giọng theo audio người bản xứ',
              tagText: 'Ngữ điệu',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SpeakingShadowingLibraryScreen()),
                );
              },
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String tagText,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon Box
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 14),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.brandTextPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              tagText,
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Arrow indicator
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
}
