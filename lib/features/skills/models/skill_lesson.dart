import 'package:flutter/material.dart';

enum SkillType {
  listening,
  reading,
  speaking,
  writing,
}

enum IeltsLevel {
  all,
  foundation, // Band 4.0 - 5.0
  intermediate, // Band 5.5 - 6.5
  advanced, // Band 7.0 - 8.5+
}

extension SkillTypeExtension on SkillType {
  String get nameVi {
    switch (this) {
      case SkillType.listening:
        return 'Listening';
      case SkillType.reading:
        return 'Reading';
      case SkillType.speaking:
        return 'Speaking';
      case SkillType.writing:
        return 'Writing';
    }
  }

  String get titleVi {
    switch (this) {
      case SkillType.listening:
        return 'Listening';
      case SkillType.reading:
        return 'Reading';
      case SkillType.speaking:
        return 'Speaking';
      case SkillType.writing:
        return 'Writing';
    }
  }

  String get descriptionVi {
    switch (this) {
      case SkillType.listening:
        return 'Luyện nghe phản xạ từ hội thoại giao tiếp cơ bản đến bài giảng học thuật chuyên sâu chuẩn đề thi IELTS.';
      case SkillType.reading:
        return 'Kỹ thuật đọc hiểu Skimming, Scanning, phân tích cấu trúc bài đọc học thuật và bẫy đề thi.';
      case SkillType.speaking:
        return 'Tự tin phản xạ Part 1, 2, 3 với phát âm chuẩn, cấu trúc ý tưởng logic và từ vựng band cao cùng AI.';
      case SkillType.writing:
        return 'Nắm chắc tiêu chí Task 1 mô tả biểu đồ & Task 2 lập luận bài luận học thuật chặt chẽ, mạch lạc.';
    }
  }

  IconData get icon {
    switch (this) {
      case SkillType.listening:
        return Icons.headphones_rounded;
      case SkillType.reading:
        return Icons.auto_stories_rounded;
      case SkillType.speaking:
        return Icons.chat_bubble_outline_rounded;
      case SkillType.writing:
        return Icons.edit_note_rounded;
    }
  }

  List<Color> get gradientColors {
    switch (this) {
      case SkillType.listening:
        return const [Color(0xFF3B82F6), Color(0xFF1D4ED8)];
      case SkillType.reading:
        return const [Color(0xFF10B981), Color(0xFF059669)];
      case SkillType.speaking:
        return const [Color(0xFFF59E0B), Color(0xFFD97706)];
      case SkillType.writing:
        return const [Color(0xFF6366F1), Color(0xFF4F46E5)];
    }
  }

  Color get primaryColor => gradientColors.first;

  Color get lightBgColor {
    switch (this) {
      case SkillType.listening:
        return const Color(0xFFEFF6FF);
      case SkillType.reading:
        return const Color(0xFFECFDF5);
      case SkillType.speaking:
        return const Color(0xFFFFFBEB);
      case SkillType.writing:
        return const Color(0xFFEEF2FF);
    }
  }

  static SkillType fromString(String str) {
    switch (str.toLowerCase()) {
      case 'reading':
        return SkillType.reading;
      case 'speaking':
        return SkillType.speaking;
      case 'writing':
        return SkillType.writing;
      case 'listening':
      default:
        return SkillType.listening;
    }
  }
}

extension IeltsLevelExtension on IeltsLevel {
  String get label {
    switch (this) {
      case IeltsLevel.all:
        return 'Tất cả';
      case IeltsLevel.foundation:
        return 'Band 4.0 - 5.0';
      case IeltsLevel.intermediate:
        return 'Band 5.5 - 6.5';
      case IeltsLevel.advanced:
        return 'Band 7.0 - 8.5+';
    }
  }

  String get subLabel {
    switch (this) {
      case IeltsLevel.all:
        return 'Tất cả cấp độ';
      case IeltsLevel.foundation:
        return 'Cơ bản (Foundation)';
      case IeltsLevel.intermediate:
        return 'Trung cấp (Intermediate)';
      case IeltsLevel.advanced:
        return 'Nâng cao (Advanced Mastery)';
    }
  }

  Color get badgeBgColor {
    switch (this) {
      case IeltsLevel.all:
        return const Color(0xFFF1F5F9);
      case IeltsLevel.foundation:
        return const Color(0xFFECFDF5);
      case IeltsLevel.intermediate:
        return const Color(0xFFEFF6FF);
      case IeltsLevel.advanced:
        return const Color(0xFFEEF2FF);
    }
  }

  Color get badgeTextColor {
    switch (this) {
      case IeltsLevel.all:
        return const Color(0xFF475569);
      case IeltsLevel.foundation:
        return const Color(0xFF059669);
      case IeltsLevel.intermediate:
        return const Color(0xFF2563EB);
      case IeltsLevel.advanced:
        return const Color(0xFF4F46E5);
    }
  }
}

class SkillLesson {
  final String id;
  final String lessonNumber;
  final String title;
  final String description;
  final SkillType skillType;
  final IeltsLevel level;
  final String bandText;
  final int durationMinutes;
  final int exerciseCount;
  final double progress; // 0.0 -> 1.0
  final bool isCompleted;
  final String topicTag;
  final List<String> keyOutcomes;

  const SkillLesson({
    required this.id,
    required this.lessonNumber,
    required this.title,
    required this.description,
    required this.skillType,
    required this.level,
    required this.bandText,
    required this.durationMinutes,
    required this.exerciseCount,
    this.progress = 0.0,
    this.isCompleted = false,
    required this.topicTag,
    this.keyOutcomes = const [],
  });
}
