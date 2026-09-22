import 'package:flutter/material.dart';

enum ArchiveCategoryType {
  cambridge,
  spelling,
  numbers,
  pronunciation,
  conversations,
}

/// Từng bài học / Part trong Library Archives
class ArchiveLessonItem {
  final String id;
  final String lessonName; // VD: 'Part 1', 'Part 2' hoặc 'English First & Last Names'
  final String? topicDescription; // VD: 'Holiday Accommodation Enquiry'
  final int questionCount; // VD: 10
  final String? testId; // Linked ListeningTest id
  final int? partNumber; // Linked part number (1..4)
  final String? dictationId; // Linked DictationExercise id

  const ArchiveLessonItem({
    required this.id,
    required this.lessonName,
    this.topicDescription,
    this.questionCount = 10,
    this.testId,
    this.partNumber,
    this.dictationId,
  });
}

/// Nhóm bài con (VD: TEST 1, TEST 2... trong 1 cuốn sách Cambridge, hoặc BÀI LUYỆN TẬP trong chuyên đề)
class ArchiveSubSection {
  final String subTitle; // 'TEST 1', 'TEST 2', 'DANH SÁCH BÀI TẬP'
  final String? testId; // 'cam20_test1'
  final int durationMinutes; // 30
  final int questionCount; // 40
  final List<ArchiveLessonItem> lessons;

  const ArchiveSubSection({
    required this.subTitle,
    this.testId,
    this.durationMinutes = 30,
    this.questionCount = 40,
    required this.lessons,
  });
}

/// Thẻ nhóm trong Library Archives (Cambridge, Spelling, Numbers...)
class ArchiveGroup {
  final String id;
  final String title; // 'CAMBRIDGE 20', 'SPELLING', 'NUMBERS', 'PRONUNCIATION', 'CONVERSATIONS'
  final String badgeText; // '4 Tests Listening', '3 Bài luyện'
  final String tagNumber; // '20', '19', 'A-Z', '#123', 'IPA', '💬'
  final Color tagBgColor;
  final Color tagTextColor;
  final bool isActive;
  final ArchiveCategoryType category;
  final List<ArchiveSubSection> subSections;

  const ArchiveGroup({
    required this.id,
    required this.title,
    required this.badgeText,
    required this.tagNumber,
    required this.tagBgColor,
    required this.tagTextColor,
    this.isActive = false,
    required this.category,
    required this.subSections,
  });
}
