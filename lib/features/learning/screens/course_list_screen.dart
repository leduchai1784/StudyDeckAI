import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  final List<Map<String, dynamic>> _courses = const [
    {
      'title': 'Tiếng Anh Giao Tiếp B1 Intermediate',
      'lessonsCount': 24,
      'completedLessons': 8,
      'level': 'Trung cấp B1',
      'duration': '12 giờ học',
      'imageColor': Color(0xFF4F46E5),
      'icon': Icons.record_voice_over,
    },
    {
      'title': 'Ngữ Pháp & Từ Vựng Tiếng Anh Công Sở',
      'lessonsCount': 18,
      'completedLessons': 5,
      'level': 'Business English',
      'duration': '8 giờ học',
      'imageColor': Color(0xFF525D83),
      'icon': Icons.work,
    },
    {
      'title': 'Luyện Thi IELTS Writing & Speaking 6.5+',
      'lessonsCount': 30,
      'completedLessons': 12,
      'level': 'IELTS Intensive',
      'duration': '18 giờ học',
      'imageColor': Color(0xFF684000),
      'icon': Icons.school,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Kho Khóa Học & Lộ Trình',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.onSurface),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryContainer.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lộ Trình Cá Nhân Hóa AI',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'AI Tutor tự động đề xuất 3 bài học ngắn mỗi ngày giúp tăng 200% ghi nhớ.',
                            style: TextStyle(color: Color(0xFFDAD7FF), fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.auto_awesome, size: 40, color: Colors.white),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Khóa Học Đang Theo Học',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
              ),
              const SizedBox(height: 12),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _courses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final course = _courses[index];
                  final completed = course['completedLessons'] as int;
                  final total = course['lessonsCount'] as int;
                  final progress = completed / total;

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: (course['imageColor'] as Color).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(course['icon'] as IconData, color: course['imageColor'] as Color, size: 28),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course['title'] as String,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${course['level']} • ${course['duration']}',
                                    style: const TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Đã hoàn thành $completed / $total bài',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryContainer),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: AppTheme.surfaceContainerLow,
                            valueColor: AlwaysStoppedAnimation<Color>(course['imageColor'] as Color),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
