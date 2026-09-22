import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../services/survey_service.dart';
import '../../../shared/widgets/survey_progress_header.dart';

class SurveyReferralScreen extends StatefulWidget {
  const SurveyReferralScreen({super.key});

  @override
  State<SurveyReferralScreen> createState() => _SurveyReferralScreenState();
}

class _SurveyReferralScreenState extends State<SurveyReferralScreen> {
  int _selectedIndex = 0;
  final SurveyService _surveyService = SurveyService();

  final List<Map<String, dynamic>> _referralChannels = [
    {
      'icon': Icons.smartphone_outlined,
      'emoji': '📱',
      'title': 'TikTok',
    },
    {
      'icon': Icons.people_outline,
      'emoji': '👥',
      'title': 'Bạn bè hoặc người thân giới thiệu',
    },
    {
      'icon': Icons.search,
      'emoji': '🔍',
      'title': 'Tìm kiếm trên Google',
    },
    {
      'icon': Icons.camera_alt_outlined,
      'emoji': '📷',
      'title': 'Facebook / Instagram',
    },
    {
      'icon': Icons.shopping_bag_outlined,
      'emoji': '🛍️',
      'title': 'Kho ứng dụng (App Store / Google Play)',
    },
    {
      'icon': Icons.article_outlined,
      'emoji': '📰',
      'title': 'Tin tức, báo chí hoặc bài viết review',
    },
  ];

  void _onContinue() {
    final selected = _referralChannels[_selectedIndex];
    _surveyService.setReferral(selected['title'] as String, selected['emoji'] as String);
    context.push('/survey-summary');
  }

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
                  // Unified Survey Progress Header (Step 4/4 - 100%)
                  const SurveyProgressHeader(currentStep: 4),
                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    'Bạn biết đến chúng mình từ\nđâu?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brandTextPrimary,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 6 Referral Channel Options List
                  Expanded(
                    child: ListView.separated(
                      itemCount: _referralChannels.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = _referralChannels[index];
                        final isSelected = _selectedIndex == index;

                        return Container(
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.chipIndigoBg : AppTheme.brandSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppTheme.brandPrimary : AppTheme.brandBorder,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                setState(() {
                                  _selectedIndex = index;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: isSelected ? AppTheme.brandSurface : AppTheme.chipIndigoBg,
                                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                                      ),
                                      child: Icon(
                                        item['icon'] as IconData,
                                        color: AppTheme.brandPrimary,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Text(
                                        item['title'] as String,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.brandTextPrimary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Radio Circle Indicator
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected ? AppTheme.brandPrimary : AppTheme.brandBorder,
                                          width: isSelected ? 6 : 2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Bottom Action Button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.brandPrimary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Tiếp tục',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                          ],
                        ),
                      ),
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
}
