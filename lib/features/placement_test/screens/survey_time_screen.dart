import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SurveyTimeScreen extends StatefulWidget {
  const SurveyTimeScreen({super.key});

  @override
  State<SurveyTimeScreen> createState() => _SurveyTimeScreenState();
}

class _SurveyTimeScreenState extends State<SurveyTimeScreen> {
  int _selectedIndex = 2; // Default 15 phút/ngày as selected in Image 4

  final List<Map<String, dynamic>> _times = [
    {
      'icon': Icons.hourglass_empty_outlined,
      'title': '5 phút/ngày',
      'subtitle': 'Nhẹ nhàng',
    },
    {
      'icon': Icons.access_time_outlined,
      'title': '10 phút/ngày',
      'subtitle': 'Vừa sức',
    },
    {
      'icon': Icons.timer_outlined,
      'title': '15 phút/ngày',
      'subtitle': 'Nghiêm túc',
    },
    {
      'icon': Icons.alarm_outlined,
      'title': '30 phút/ngày',
      'subtitle': 'Cấp tốc',
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
                  // Back & Brand Header (Image 4)
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Color(0xFF181445)),
                          onPressed: () => context.pop(),
                        ),
                      ),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Header Progress Labels (LỘ TRÌNH HỌC TẬP | Bước 3/4)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'LỘ TRÌNH HỌC TẬP',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3525CD),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Bước 3/4',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: const Color(0xFF525D83),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: const LinearProgressIndicator(
                      value: 0.75,
                      minHeight: 6,
                      backgroundColor: Color(0xFFE9E5FF),
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4F46E5)),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Title (Image 4)
                  const Text(
                    'Mỗi ngày bạn muốn dành\nbao nhiêu thời gian?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF181445),
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // 4 Time Options List (Image 4)
                  Expanded(
                    child: ListView.separated(
                      itemCount: _times.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final item = _times[index];
                        final isSelected = _selectedIndex == index;

                        return Container(
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFF0EEFF) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF3525CD) : const Color(0xFFE3DFFF),
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
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEFEBFF),
                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                      ),
                                      child: Icon(
                                        item['icon'] as IconData,
                                        color: const Color(0xFF181445),
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
                                              color: Color(0xFF181445),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item['subtitle'] as String,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFF464555),
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
                                          color: isSelected ? const Color(0xFF3525CD) : const Color(0xFFC7C4D8),
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

                  // Bottom Button (Image 4)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.push('/survey-start');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3525CD),
                          foregroundColor: Colors.white,
                          elevation: 2,
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
