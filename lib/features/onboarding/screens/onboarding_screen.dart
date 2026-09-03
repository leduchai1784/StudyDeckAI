import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/stitch_bento_card.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF9FAFB),
              Color(0xFFEFEFEE),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  children: [
                    const Spacer(),
                    // StudyDeck AI Brand Logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5A4FE3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.auto_awesome_motion,
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'StudyDeck',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: const Color(0xFF181445),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFB95F),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'AI Học tiếng Anh thông minh',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2A1700),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Học tiếng Anh thông minh với AI',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF181445),
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Nâng cao kỹ năng với phương pháp học tập được cá nhân hóa và sự hỗ trợ của trí tuệ nhân tạo.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF464555),
                            fontSize: 15,
                            height: 1.4,
                          ),
                    ),
                    const Spacer(),

                    // 3 Bento Feature Cards (Image 1)
                    StitchBentoCard(
                      icon: Icons.psychology,
                      title: 'AI Tutor 24/7',
                      description: 'Sửa lỗi và giải thích ngữ pháp tức thì.',
                      iconBackgroundColor: const Color(0xFFEFEBFF),
                      iconColor: const Color(0xFF4F46E5),
                      onTap: () => context.push('/survey-goal'),
                    ),
                    StitchBentoCard(
                      icon: Icons.style,
                      title: 'Flashcards Thông Minh',
                      description: 'Học từ vựng hiệu quả với lặp lại ngắt quãng.',
                      iconBackgroundColor: const Color(0xFFEFEBFF),
                      iconColor: const Color(0xFF4F46E5),
                      onTap: () => context.push('/survey-goal'),
                    ),
                    StitchBentoCard(
                      icon: Icons.tune,
                      title: 'Cá Nhân Hóa',
                      description: 'Lộ trình học tối ưu dựa trên năng lực của bạn.',
                      iconBackgroundColor: const Color(0xFFFFDDB8).withValues(alpha: 0.4),
                      iconColor: const Color(0xFF684000),
                      onTap: () => context.push('/survey-goal'),
                    ),
                    const Spacer(),

                    // Buttons (Image 1)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.push('/survey-goal'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: const Text(
                          'Bắt đầu ngay',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.push('/login'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF4F46E5),
                          side: const BorderSide(color: Color(0xFFC3C0FF)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: const Text(
                          'Tôi đã có tài khoản',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
