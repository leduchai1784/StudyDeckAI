import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../services/survey_service.dart';
import '../../../shared/widgets/survey_progress_header.dart';

class SurveySummaryScreen extends StatefulWidget {
  const SurveySummaryScreen({super.key});

  @override
  State<SurveySummaryScreen> createState() => _SurveySummaryScreenState();
}

class _SurveySummaryScreenState extends State<SurveySummaryScreen> {
  final SurveyService _surveyService = SurveyService();

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
                  // Full Progress Header (Step 4/4 - 100% completed)
                  const SurveyProgressHeader(currentStep: 4),
                  const SizedBox(height: 16),

                  // Top Circle Icon Checkmark
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: AppTheme.chipIndigoBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppTheme.brandPrimary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Headline & Subtitle matching screenshot
                  const Text(
                    'Cảm ơn bạn! 🎉',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brandTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'StudyDeck AI đã ghi nhận thông tin của bạn và\nđang bắt đầu cá nhân hóa lộ trình học.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.brandTextSecondary,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Main Scrollable Area for All 4 Dynamic Summary Cards
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Interactive Card: THÔNG TIN CỦA BẠN — CHẠM ĐỂ SỬA
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.brandSurface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.brandBorder),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'THÔNG TIN CỦA BẠN — CHẠM ĐỂ SỬA',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.brandTextMuted,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Item 1: Mục tiêu học (Bước 1/4)
                                _buildEditRow(
                                  iconWidget: Text(_surveyService.selectedGoalIcon, style: const TextStyle(fontSize: 18)),
                                  title: _surveyService.selectedGoalTitle,
                                  onTap: () async {
                                    await context.push('/survey-goal');
                                    setState(() {});
                                  },
                                ),
                                const Divider(height: 20, color: AppTheme.brandBorder),

                                // Item 2: Trình độ hiện tại (Bước 2/4)
                                _buildEditRow(
                                  iconWidget: Text(_surveyService.selectedLevelIcon, style: const TextStyle(fontSize: 18)),
                                  title: _surveyService.selectedLevelTitle,
                                  onTap: () async {
                                    await context.push('/survey-level');
                                    setState(() {});
                                  },
                                ),
                                const Divider(height: 20, color: AppTheme.brandBorder),

                                // Item 3: Thời gian học (Bước 3/4)
                                _buildEditRow(
                                  iconWidget: Text(_surveyService.selectedTimeIcon, style: const TextStyle(fontSize: 18)),
                                  title: _surveyService.selectedTimeTitle,
                                  onTap: () async {
                                    await context.push('/survey-time');
                                    setState(() {});
                                  },
                                ),
                                const Divider(height: 20, color: AppTheme.brandBorder),

                                // Item 4: Nguồn biết đến StudyDeck (Bước 4/4)
                                _buildEditRow(
                                  iconWidget: Text(_surveyService.selectedReferralIcon, style: const TextStyle(fontSize: 18)),
                                  title: _surveyService.selectedReferralTitle,
                                  onTap: () async {
                                    await context.push('/survey-referral');
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Gold Highlight Banner
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.tintAmberBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.brandAccent.withValues(alpha: 0.3)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.auto_awesome, color: AppTheme.brandAccent, size: 22),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Tạo tài khoản ngay để AI hoàn tất và mở khóa lộ trình riêng của bạn',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.tintAmberText,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Buttons Section
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Primary Button: Tạo tài khoản để xem lộ trình
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              context.push('/register?fromSurvey=true');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.brandPrimary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Tạo tài khoản để xem lộ trình',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Sub-link 1: Đã có tài khoản? Đăng nhập
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Đã có tài khoản? ',
                              style: TextStyle(fontSize: 14, color: AppTheme.brandTextSecondary),
                            ),
                            GestureDetector(
                              onTap: () => context.push('/login?fromSurvey=true'),
                              child: const Text(
                                'Đăng nhập',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.brandPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditRow({
    required Widget iconWidget,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            iconWidget,
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brandTextPrimary,
                ),
              ),
            ),
            const Icon(
              Icons.mode_edit_outline_outlined,
              size: 18,
              color: AppTheme.brandTextMuted,
            ),
          ],
        ),
      ),
    );
  }
}
