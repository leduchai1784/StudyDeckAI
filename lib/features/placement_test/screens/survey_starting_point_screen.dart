import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SurveyStartingPointScreen extends StatelessWidget {
  const SurveyStartingPointScreen({super.key});

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
                  // Back & Brand Header (Image 5)
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

                  // Header Progress Labels (BƯỚC 4/4 | Sắp hoàn thành!)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'BƯỚC 4/4',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3525CD),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Sắp hoàn thành!',
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
                      value: 1.0,
                      minHeight: 6,
                      backgroundColor: Color(0xFFE9E5FF),
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3525CD)),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Headline & Subtitle (Image 5)
                  const Text(
                    'Chọn điểm khởi đầu của\nbạn',
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
                    'Chúng tôi sẽ tùy chỉnh lộ trình học dựa\ntrên trình độ hiện tại của bạn.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF464555),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Option Card 1: Bắt đầu từ số 0
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE3DFFF)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEFEBFF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.school_outlined, color: Color(0xFF4F46E5), size: 26),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Bắt đầu từ số 0',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF181445)),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Tôi là người mới bắt đầu. Hãy đưa tôi vào bài học vỡ lòng đầu tiên.',
                          style: TextStyle(fontSize: 13, color: Color(0xFF464555), height: 1.35),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => context.push('/ai-assessment'),
                          child: const Row(
                            children: [
                              Text(
                                'Bắt đầu ngay',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3525CD),
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward, size: 16, color: Color(0xFF3525CD)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Option Card 2: Kiểm tra trình độ (Khuyên dùng - Yellow Border/Badge) (Image 5)
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF39C12), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFEF9E7),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.lightbulb_outline, color: Color(0xFFF39C12), size: 26),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Kiểm tra trình độ',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF181445)),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Tôi đã có kiến thức nền tảng. Làm bài test nhanh 3 phút để StudyDeck AI xếp lớp phù hợp.',
                              style: TextStyle(fontSize: 13, color: Color(0xFF464555), height: 1.35),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => context.push('/ai-assessment'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF39C12),
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Làm bài kiểm tra (3 phút)',
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(Icons.timer_outlined, size: 18, color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Badge "Khuyên dùng" Top Right
                      Positioned(
                        top: -1,
                        right: -1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF39C12),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(14),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Khuyên dùng',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Bottom link: Bỏ qua bước này, tôi sẽ chọn sau
                  TextButton(
                    onPressed: () => context.push('/ai-assessment'),
                    child: const Text(
                      'Bỏ qua bước này, tôi sẽ chọn sau',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF464555),
                        fontWeight: FontWeight.w500,
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
    );
  }
}
