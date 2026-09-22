import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../shared/widgets/studydeck_logo_header.dart';

class SurveyStartingPointScreen extends StatelessWidget {
  const SurveyStartingPointScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top Bar: Unified Back Button & Brand Header Badge
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppTheme.brandTextPrimary),
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/onboarding');
                          }
                        },
                      ),
                      const Spacer(),
                      const StudyDeckHeaderBadge(iconSize: 24),
                      const Spacer(),
                      const SizedBox(width: 48), // Balance spacing
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Heading
                  const Text(
                    'Bạn muốn bắt đầu\ntừ đâu?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brandTextPrimary,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Chúng tôi sẽ tùy chỉnh lộ trình học dựa\ntrên trình độ hiện tại của bạn.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.brandTextSecondary,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Option Card 1: Bắt đầu từ số 0
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.brandSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.brandBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: AppTheme.chipIndigoBg,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.school_outlined, color: AppTheme.brandPrimary, size: 26),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Bắt đầu từ số 0',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.brandTextPrimary),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Tôi là người mới bắt đầu. Hãy đưa tôi vào bài học vỡ lòng đầu tiên.',
                          style: TextStyle(fontSize: 13, color: AppTheme.brandTextSecondary, height: 1.35),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => context.go('/'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.brandPrimary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Bắt đầu ngay',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                SizedBox(width: 6),
                                Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Option Card 2: Kiểm tra trình độ (Khuyên dùng)
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.brandSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.brandBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: AppTheme.chipIndigoBg,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.lightbulb_outline, color: AppTheme.brandPrimary, size: 26),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Kiểm tra trình độ',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.brandTextPrimary),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Tôi đã có kiến thức nền tảng. Làm bài test nhanh 3 phút để StudyDeck AI xếp lớp phù hợp.',
                              style: TextStyle(fontSize: 13, color: AppTheme.brandTextSecondary, height: 1.35),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => context.push('/survey-goal'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.brandPrimary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Làm bài kiểm tra (3 phút)',
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(Icons.timer_outlined, size: 18, color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Badge "Khuyên dùng" Top Right
                      Positioned(
                        top: -1,
                        right: -1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: const BoxDecoration(
                            color: AppTheme.brandPrimary,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Khuyên dùng',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Bottom link: Bỏ qua bước này, tôi sẽ chọn sau
                  TextButton(
                    onPressed: () => context.go('/'),
                    child: const Text(
                      'Bỏ qua bước này, tôi sẽ chọn sau',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.brandTextSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
