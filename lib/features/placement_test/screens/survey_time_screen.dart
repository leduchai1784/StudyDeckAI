import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../services/survey_service.dart';
import '../../../shared/widgets/survey_progress_header.dart';

class SurveyTimeScreen extends StatefulWidget {
  const SurveyTimeScreen({super.key});

  @override
  State<SurveyTimeScreen> createState() => _SurveyTimeScreenState();
}

class _SurveyTimeScreenState extends State<SurveyTimeScreen> {
  int _selectedIndex = 2; // Default 15 phút/ngày
  final SurveyService _surveyService = SurveyService();

  final List<Map<String, dynamic>> _times = [
    {
      'icon': Icons.hourglass_empty_outlined,
      'emoji': '⏱️',
      'title': '5 phút/ngày',
      'subtitle': 'Nhẹ nhàng',
    },
    {
      'icon': Icons.access_time_outlined,
      'emoji': '⏱️',
      'title': '10 phút/ngày',
      'subtitle': 'Vừa sức',
    },
    {
      'icon': Icons.timer_outlined,
      'emoji': '⏱️',
      'title': '15 phút/ngày',
      'subtitle': 'Nghiêm túc',
    },
    {
      'icon': Icons.alarm_outlined,
      'emoji': '⏱️',
      'title': '30 phút/ngày',
      'subtitle': 'Cấp tốc',
    },
  ];

  void _onContinue() {
    final selected = _times[_selectedIndex];
    _surveyService.setTime(selected['title'] as String, selected['emoji'] as String);
    context.push('/survey-referral');
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
                  // Unified Survey Progress Header (Step 3/4 - 75%)
                  const SurveyProgressHeader(currentStep: 3),
                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    'Mỗi ngày bạn muốn dành\nbao nhiêu thời gian?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brandTextPrimary,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // 4 Time Options List
                  Expanded(
                    child: ListView.separated(
                      itemCount: _times.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final item = _times[index];
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
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['title'] as String,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.brandTextPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item['subtitle'] as String,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: AppTheme.brandTextSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
