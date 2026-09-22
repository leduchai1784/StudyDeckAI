import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../services/survey_service.dart';
import '../../../shared/widgets/survey_progress_header.dart';

class SurveyGoalScreen extends StatefulWidget {
  const SurveyGoalScreen({super.key});

  @override
  State<SurveyGoalScreen> createState() => _SurveyGoalScreenState();
}

class _SurveyGoalScreenState extends State<SurveyGoalScreen> {
  final SurveyService _surveyService = SurveyService();

  final List<Map<String, dynamic>> _goals = [
    {
      'title': 'Cơ hội nghề nghiệp & Thăng tiến',
      'subtitle': 'Phỏng vấn, giao tiếp công sở, email, đàm phán',
      'icon': Icons.work_outline,
      'emoji': '💼',
    },
    {
      'title': 'Luyện thi chứng chỉ quốc tế',
      'subtitle': 'IELTS, TOEIC, TOEFL, VSTEP',
      'icon': Icons.school_outlined,
      'emoji': '🎓',
    },
    {
      'title': 'Du lịch & Định cư nước ngoài',
      'subtitle': 'Tự tin giao tiếp tại sân bay, khách sạn, nhà hàng',
      'icon': Icons.flight_takeoff_outlined,
      'emoji': '✈️',
    },
    {
      'title': 'Giao tiếp hàng ngày trôi chảy',
      'subtitle': 'Tự tin trò chuyện với bạn bè quốc tế, xem phim',
      'icon': Icons.chat_bubble_outline,
      'emoji': '💬',
    },
    {
      'title': 'Phát triển bản thân & Rèn luyện trí não',
      'subtitle': 'Học thêm một ngôn ngữ để mở rộng tư duy',
      'icon': Icons.psychology_outlined,
      'emoji': '🧠',
    },
  ];

  int _selectedIndex = 0;

  void _onContinue() {
    final selected = _goals[_selectedIndex];
    _surveyService.setGoal(selected['title'] as String, selected['emoji'] as String);
    context.push('/survey-level');
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
                  // Unified Survey Progress Header (Step 1/4)
                  const SurveyProgressHeader(currentStep: 1),
                  const SizedBox(height: 24),

                  // Title & Subtitle
                  const Text(
                    'Bạn muốn học tiếng Anh\nđể làm gì?',
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
                    'Chọn mục tiêu chính để StudyDeck có thể cá\nnhân hóa lộ trình học cho bạn.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.brandTextSecondary,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 5 Options List
                  Expanded(
                    child: ListView.separated(
                      itemCount: _goals.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = _goals[index];
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
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        item['icon'] as IconData,
                                        color: AppTheme.brandPrimary,
                                        size: 22,
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
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.brandTextPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item['subtitle'] as String,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppTheme.brandTextSecondary,
                                            ),
                                          ),
                                        ],
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
