import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../services/auth_service.dart';
import '../../../shared/widgets/stitch_bento_card.dart';
import '../../../shared/widgets/studydeck_logo_header.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final AuthService _authService = AuthService();
  bool _isCheckingAuth = true;

  @override
  void initState() {
    super.initState();
    _checkInitialAuth();
  }

  Future<void> _checkInitialAuth() async {
    final isLoggedIn = await _authService.isUserLoggedIn();
    if (!mounted) return;

    if (isLoggedIn) {
      context.go('/');
    } else {
      setState(() {
        _isCheckingAuth = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingAuth) {
      return const Scaffold(
        backgroundColor: AppTheme.brandBackground,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      children: [
                        const Spacer(),
                        // Official StudyDeck AI Brand Badge Logo Header
                        const StudyDeckHeaderBadge(iconSize: 32),
                        const SizedBox(height: 20),

                        const Text(
                          'Học tiếng Anh thông\nminh với AI',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.brandTextPrimary,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Nâng cao kỹ năng với phương pháp học\ntập được cá nhân hóa và sự hỗ trợ của trí\ntuệ nhân tạo.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.brandTextSecondary,
                            fontSize: 14,
                            height: 1.35,
                          ),
                        ),
                        const Spacer(),

                        // 3 Bento Feature Cards (Static Display Cards)
                        const StitchBentoCard(
                          icon: Icons.psychology_rounded,
                          title: 'AI Tutor 24/7',
                          description: 'Sửa lỗi và giải thích ngữ pháp tức\nthì.',
                          iconBackgroundColor: AppTheme.tintIndigoBg,
                          iconColor: AppTheme.tintIndigoText,
                        ),
                        const StitchBentoCard(
                          icon: Icons.style_outlined,
                          title: 'Flashcards Thông Minh',
                          description: 'Học từ vựng hiệu quả với lặp lại\nngắt quãng.',
                          iconBackgroundColor: AppTheme.tintGreenBg,
                          iconColor: AppTheme.tintGreenText,
                        ),
                        const StitchBentoCard(
                          icon: Icons.tune_rounded,
                          title: 'Cá Nhân Hóa',
                          description: 'Lộ trình học tối ưu dựa trên năng\nlực của bạn.',
                          iconBackgroundColor: AppTheme.brandAccentLight,
                          iconColor: AppTheme.tintAmberText,
                        ),
                        const Spacer(),

                        // Bottom Action Buttons
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => context.push('/survey-goal'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.brandPrimary,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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
                          child: ElevatedButton(
                            onPressed: () => context.push('/login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.chipIndigoBg,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Tôi đã có tài khoản',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.brandPrimary),
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
          ),
        ),
      ),
    );
  }
}
