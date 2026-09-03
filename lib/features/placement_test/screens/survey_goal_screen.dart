import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SurveyGoalScreen extends StatefulWidget {
  const SurveyGoalScreen({super.key});

  @override
  State<SurveyGoalScreen> createState() => _SurveyGoalScreenState();
}

class _SurveyGoalScreenState extends State<SurveyGoalScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _goals = [
    {
      'icon': Icons.flight,
      'title': 'Du lịch & Khám phá',
      'subtitle': 'Tự tin giao tiếp khi đi nước ngoài',
    },
    {
      'icon': Icons.business_center_outlined,
      'title': 'Thăng tiến công việc',
      'subtitle': 'Mở rộng cơ hội nghề nghiệp toàn cầu',
    },
    {
      'icon': Icons.school_outlined,
      'title': 'Luyện thi (IELTS/TOEIC)',
      'subtitle': 'Đạt điểm mục tiêu với lộ trình chuẩn',
    },
    {
      'icon': Icons.chat_bubble_outline,
      'title': 'Giao tiếp hằng ngày',
      'subtitle': 'Nói tiếng Anh trôi chảy, tự nhiên',
    },
    {
      'icon': Icons.favorite_border,
      'title': 'Sở thích cá nhân',
      'subtitle': 'Xem phim, đọc sách, nghe nhạc',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF8FF),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top Brand Header & Progress (Image 2)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5A4FE3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.auto_awesome_motion, size: 18, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'StudyDeck AI',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF181445)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Progress Bar 25% (Step 1/4)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: const LinearProgressIndicator(
                      value: 0.25,
                      minHeight: 6,
                      backgroundColor: Color(0xFFE9E5FF),
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4F46E5)),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title & Subtitle
                  const Text(
                    'Bạn muốn học tiếng Anh\nđể làm gì?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF181445),
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Chọn mục tiêu chính để StudyDeck có thể cá\nnhân hóa lộ trình học cho bạn.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF464555),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 5 Options List (Image 2)
                  Expanded(
                    child: ListView.separated(
                      itemCount: _goals.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = _goals[index];
                        final isSelected = _selectedIndex == index;

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE3DFFF),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
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
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEFEBFF),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        item['icon'] as IconData,
                                        color: const Color(0xFF4F46E5),
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
                                              color: Color(0xFF181445),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item['subtitle'] as String,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF464555),
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

                  // Bottom Button (Image 2)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.push('/survey-level');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE5E0FF),
                          foregroundColor: const Color(0xFF3525CD),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Tiếp tục',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF3525CD)),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 20, color: Color(0xFF3525CD)),
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
