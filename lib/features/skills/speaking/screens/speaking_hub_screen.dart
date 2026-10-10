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
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Section Title: Kho Đề Thi IELTS (3 Phần Thi)
            const Text(
              'KHO ĐỀ THI IELTS (3 PHẦN THI)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.brandTextSecondary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),

            // 1. Part 1 Bắt Buộc Tile
            _buildActionTile(
              context: context,
              icon: Icons.push_pin_rounded,
              iconBgColor: const Color(0xFFFEF3C7),
              iconColor: const Color(0xFFD97706),
              title: 'Part 1: Bắt Buộc',
              subtitle: 'Where you live now & Work / Study (21 câu hỏi).',
              tagText: '2 đề',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SpeakingPart1CompulsoryScreen()),
                );
              },
            ),
            const SizedBox(height: 10),

            // 2. Part 2 Chủ Đề Tile
            _buildActionTile(
              context: context,
              icon: Icons.record_voice_over_rounded,
              iconBgColor: const Color(0xFFEFF6FF),
              iconColor: const Color(0xFF2563EB),
              title: 'Part 2: Chủ Đề',
              subtitle: '44 chủ đề dự đoán thi thật (196 câu hỏi).',
              tagText: '44 đề',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SpeakingPart1TopicsScreen()),
                );
              },
            ),
            const SizedBox(height: 10),

            // 3. Part 3 Tile
            _buildActionTile(
              context: context,
              icon: Icons.timer_outlined,
              iconBgColor: const Color(0xFFEDE9FE),
              iconColor: const Color(0xFF7C3AED),
              title: 'Part 3: Thuyết Trình & Thảo Luận',
              subtitle: '66 đề Cue Card 2 phút & 293 câu hỏi thảo luận Part 3.',
              tagText: '66 đề',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SpeakingPart23Screen()),
                );
              },
            ),
            const SizedBox(height: 22),

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
            const SizedBox(height: 10),

            // Action Tiles List
            _buildActionTile(
              context: context,
              icon: Icons.casino_rounded,
              iconBgColor: const Color(0xFFEEF2FF),
              iconColor: const Color(0xFF4F46E5),
              title: 'Vòng Quay Bốc Bài',
              subtitle: 'Rút thẻ câu hỏi ngẫu nhiên và phản xạ nhanh.',
              tagText: 'Phản xạ',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SpeakingRouletteScreen()),
                );
              },
            ),
            const SizedBox(height: 10),

            _buildActionTile(
              context: context,
              icon: Icons.psychology_rounded,
              iconBgColor: const Color(0xFFECFDF5),
              iconColor: const Color(0xFF059669),
              title: 'Phòng Thi Giám Khảo AI',
              subtitle: 'Phỏng vấn trực tiếp và chấm điểm 4 tiêu chí IELTS.',
              tagText: 'Chấm AI',
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
            const SizedBox(height: 10),

            _buildActionTile(
              context: context,
              icon: Icons.record_voice_over_rounded,
              iconBgColor: const Color(0xFFFFFBEB),
              iconColor: const Color(0xFFD97706),
              title: 'Luyện Ngữ Điệu Shadowing',
              subtitle: 'Nghe giọng bản xứ, ghi âm nhại theo và nhận chấm điểm AI.',
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

  // Streamlined Action Tile Component
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 19),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.brandTextPrimary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tagText,
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
