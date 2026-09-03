import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SurveyCurrentLevelScreen extends StatefulWidget {
  const SurveyCurrentLevelScreen({super.key});

  @override
  State<SurveyCurrentLevelScreen> createState() => _SurveyCurrentLevelScreenState();
}

class _SurveyCurrentLevelScreenState extends State<SurveyCurrentLevelScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _levels = [
    {
      'icon': Icons.psychology_alt_outlined,
      'title': 'Mới bắt đầu hoàn toàn',
      'subtitle': 'Chưa từng học hoặc quên gần hết.',
    },
    {
      'icon': Icons.translate_outlined,
      'title': 'Biết một vài từ cơ bản',
      'subtitle': 'Có thể hiểu những câu rất đơn giản.',
    },
    {
      'icon': Icons.chat_bubble_outline_sharp,
      'title': 'Giao tiếp được câu đơn giản',
      'subtitle': 'Hiểu và phản hồi được trong tình huống quen thuộc.',
    },
    {
      'icon': Icons.language_outlined,
      'title': 'Tự tin nói nhiều chủ đề',
      'subtitle': 'Sử dụng tiếng Anh khá linh hoạt và trôi chảy.',
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
                  // Back & Brand Header (Image 3)
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

                  // Progress & Step label (Step 2 of 4 - 50%)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Step 2 of 4',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: const Color(0xFF525D83),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: const LinearProgressIndicator(
                      value: 0.50,
                      minHeight: 6,
                      backgroundColor: Color(0xFFE9E5FF),
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4F46E5)),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Title & Subtitle
                  const Text(
                    'Trình độ tiếng Anh của\nbạn ở mức nào?',
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
                    'Giúp chúng tôi điều chỉnh lộ trình học tập phù\nhợp nhất với bạn.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF464555),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4 Options List with Radio Circle (Image 3)
                  Expanded(
                    child: ListView.separated(
                      itemCount: _levels.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final item = _levels[index];
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
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
                                          const SizedBox(height: 4),
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
                                    const SizedBox(width: 8),
                                    // Radio Circle Indicator
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFC7C4D8),
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

                  // Bottom Button (Image 3)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.push('/survey-time');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
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
