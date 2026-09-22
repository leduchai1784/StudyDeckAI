import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../models/archive_model.dart';
import '../models/listening_test_model.dart';
import '../models/dictation_model.dart';
import '../data/listening_mock_data.dart';
import 'listening_test_screen.dart';
import 'listening_dictation_screen.dart';

class ArchiveLessonsListScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<ArchiveLessonItem> lessons;
  final String? testId; // Nếu là test Cambridge, cho phép làm cả bài
  final bool isCambridgeTest;

  const ArchiveLessonsListScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.lessons,
    this.testId,
    this.isCambridgeTest = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppTheme.brandTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
            color: AppTheme.brandTextPrimary,
          ),
        ),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Text(
              '${lessons.length} Phần',
              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Banner: Nếu là Test Cambridge, có nút làm cả đề
            if (isCambridgeTest) ...[
              _buildFullTestBanner(context),
              const SizedBox(height: 16),
            ],

            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isCambridgeTest ? 'DANH SÁCH CÁC PART (LUYỆN LẺ)' : 'DANH SÁCH BÀI LUYỆN TẬP',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandTextSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Danh sách các bài học / Part
            ...lessons.map((lesson) => _buildLessonCard(context, lesson)),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Banner làm trọn vẹn cả Test
  Widget _buildFullTestBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.timer_outlined, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thi Thử Toàn Bộ Đề',
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 2),
                Text(
                  '40 câu hỏi · 30 phút · Bấm giờ thi thật',
                  style: TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ListeningTest targetTest;
              if (testId != null) {
                try {
                  targetTest = ListeningMockData.allTests.firstWhere((t) => t.id == testId);
                } catch (_) {
                  targetTest = ListeningMockData.allTests.first;
                }
              } else {
                targetTest = ListeningMockData.allTests.first;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListeningTestScreen(
                    test: targetTest,
                    isRealTest: true,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.brandPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: const Text('Bắt Đầu Thi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Thẻ từng bài học / Part
  Widget _buildLessonCard(BuildContext context, ArchiveLessonItem lesson) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Header bài
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.description_outlined, size: 18, color: Color(0xFF475569)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.lessonName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brandTextPrimary,
                      ),
                    ),
                    if (lesson.topicDescription != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        lesson.topicDescription!,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.3),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: const Color(0xFFF1F5F9)),
          const SizedBox(height: 10),

          // Row 2: 2 nút hành động [DICTATION] và [START]
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${lesson.questionCount} câu hỏi',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                ),
              ),
              const Spacer(),

              // Nút DICTATION
              InkWell(
                onTap: () {
                  DictationExercise targetEx;
                  if (lesson.dictationId != null) {
                    try {
                      targetEx = ListeningMockData.dictationExercises.firstWhere((e) => e.id == lesson.dictationId);
                    } catch (_) {
                      targetEx = ListeningMockData.dictationExercises.first;
                    }
                  } else {
                    targetEx = ListeningMockData.dictationExercises.first;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListeningDictationScreen(exercise: targetEx),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFCBD5E1), width: 1.0),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_note_rounded, size: 15, color: Color(0xFF475569)),
                      SizedBox(width: 4),
                      Text(
                        'DICTATION',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF475569),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Nút START
              InkWell(
                onTap: () {
                  ListeningTest targetTest;
                  if (lesson.testId != null) {
                    try {
                      targetTest = ListeningMockData.allTests.firstWhere((t) => t.id == lesson.testId);
                    } catch (_) {
                      targetTest = ListeningMockData.allTests.first;
                    }
                  } else {
                    targetTest = ListeningMockData.allTests.first;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListeningTestScreen(
                        test: targetTest,
                        targetPartNumber: lesson.partNumber,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow_rounded, size: 15, color: Colors.white),
                      SizedBox(width: 3),
                      Text(
                        'START',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
