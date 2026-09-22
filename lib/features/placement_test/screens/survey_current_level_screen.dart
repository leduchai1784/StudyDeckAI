import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../services/survey_service.dart';
import '../../../shared/widgets/survey_progress_header.dart';

class SurveyCurrentLevelScreen extends StatefulWidget {
  const SurveyCurrentLevelScreen({super.key});

  @override
  State<SurveyCurrentLevelScreen> createState() => _SurveyCurrentLevelScreenState();
}

class _SurveyCurrentLevelScreenState extends State<SurveyCurrentLevelScreen> {
  int _selectedIndex = 0;
  final SurveyService _surveyService = SurveyService();

  final List<Map<String, dynamic>> _levels = [
    {
      'icon': Icons.psychology_alt_outlined,
      'emoji': '💡',
      'title': 'Mới bắt đầu hoàn toàn',
      'subtitle': 'Chưa từng học hoặc quên gần hết.',
    },
    {
      'icon': Icons.translate_outlined,
      'emoji': '🔤',
      'title': 'Biết một vài từ cơ bản',
      'subtitle': 'Có thể hiểu những câu rất đơn giản.',
    },
    {
      'icon': Icons.chat_bubble_outline_sharp,
      'emoji': '💬',
      'title': 'Giao tiếp được câu đơn giản',
      'subtitle': 'Hiểu và phản hồi được trong tình huống quen thuộc.',
    },
    {
      'icon': Icons.language_outlined,
      'emoji': '🌐',
      'title': 'Tự tin nói nhiều chủ đề',
      'subtitle': 'Sử dụng tiếng Anh khá linh hoạt và trôi chảy.',
    },
  ];

  void _onContinue() {
    final selected = _levels[_selectedIndex];
    _surveyService.setLevel(selected['title'] as String, selected['emoji'] as String);
    context.push('/survey-time');
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
                  // Unified Survey Progress Header (Step 2/4 - 50%)
                  const SurveyProgressHeader(currentStep: 2),
                  const SizedBox(height: 24),

                  // Title & Subtitle
                  const Text(
                    'Trình độ tiếng Anh của\nbạn ở mức nào?',
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
                    'Giúp chúng tôi điều chỉnh lộ trình học tập phù\nhợp nhất với bạn.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.brandTextSecondary,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4 Options List
                  Expanded(
                    child: ListView.separated(
                      itemCount: _levels.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final item = _levels[index];
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
                                          const SizedBox(height: 4),
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
