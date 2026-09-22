import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../models/skill_lesson.dart';
import '../data/skill_lessons_data.dart';
import '../data/listening_mock_data.dart';
import 'listening_test_screen.dart';
import 'listening_dictation_screen.dart';
import 'listening_ipa_screen.dart';
import 'listening_hub_screen.dart';
import '../../reading/screens/reading_hub_screen.dart';
import '../../speaking/screens/speaking_hub_screen.dart';
import '../../writing/screens/writing_hub_screen.dart';

class SkillDetailScreen extends StatefulWidget {
  final String skillType;

  const SkillDetailScreen({
    super.key,
    required this.skillType,
  });

  @override
  State<SkillDetailScreen> createState() => _SkillDetailScreenState();
}

class _SkillDetailScreenState extends State<SkillDetailScreen> {
  late SkillType _skill;
  IeltsLevel _selectedLevel = IeltsLevel.all;
  int _listeningModeIndex = 0; // 0: Đề thi, 1: Dictation, 2: IPA

  @override
  void initState() {
    super.initState();
    _skill = SkillTypeExtension.fromString(widget.skillType);
  }

  @override
  void didUpdateWidget(covariant SkillDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.skillType != widget.skillType) {
      setState(() {
        _skill = SkillTypeExtension.fromString(widget.skillType);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dedicated IELTS Practice Hub for Listening
    if (_skill == SkillType.listening) {
      return const ListeningHubScreen();
    }

    // Dedicated IELTS Practice Hub for Reading
    if (_skill == SkillType.reading) {
      return const ReadingHubScreen();
    }

    // Dedicated IELTS Practice Hub for Speaking
    if (_skill == SkillType.speaking) {
      return const SpeakingHubScreen();
    }

    // Dedicated IELTS Practice Hub for Writing
    if (_skill == SkillType.writing) {
      return const WritingHubScreen();
    }

    final allLessons = SkillLessonsData.getLessonsForSkill(_skill);
    final displayedLessons = SkillLessonsData.getLessonsForSkillAndLevel(_skill, _selectedLevel);
    final completedCount = allLessons.where((l) => l.isCompleted).length;

    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppTheme.onSurface),
          tooltip: 'Quay lại',
          onPressed: () => context.pop(),
        ),
        title: Text(
          _skill.nameVi,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppTheme.brandTextPrimary,
          ),
        ),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _skill.lightBgColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: _skill.primaryColor.withValues(alpha: 0.25)),
            ),
            child: Text(
              '${allLessons.length} bài',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _skill.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Banner Gradient (Theme Vuông 8px)
              _buildHeaderBanner(allLessons.length, completedCount),
              const SizedBox(height: 18),

              // Listening Specific Modes: Đề thi Cambridge, Dictation, IPA
              if (_skill == SkillType.listening) ...[
                _buildListeningModeSelector(),
                const SizedBox(height: 16),
              ],

              // Content according to selected mode
              if (_skill == SkillType.listening && _listeningModeIndex == 1)
                _buildDictationSection()
              else if (_skill == SkillType.listening && _listeningModeIndex == 2)
                _buildIpaSection()
              else ...[
                // 2. IELTS Level Filter Bar
                _buildLevelFilterTabs(),
                const SizedBox(height: 16),

                // 3. Section Title & Lesson Count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedLevel == IeltsLevel.all
                          ? 'Danh sách bài học'
                          : 'Bài học ${_selectedLevel.label}',
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brandTextPrimary,
                      ),
                    ),
                    Text(
                      '${displayedLessons.length} bài',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 4. Lessons List
                if (displayedLessons.isEmpty)
                  _buildEmptyState()
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayedLessons.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final lesson = displayedLessons[index];
                      return _buildLessonCard(lesson);
                    },
                  ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Header Banner (Tối giản, gọn gàng)
  Widget _buildHeaderBanner(int totalLessons, int completedCount) {
    final double percent = totalLessons > 0 ? (completedCount / totalLessons) : 0.0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _skill.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: _skill.primaryColor.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Lộ trình ${_skill.nameVi}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Band 4.0 – 8.5+  •  $completedCount/$totalLessons bài hoàn thành',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percent,
                    minHeight: 4,
                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _skill.icon,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  // 2. Level Filter Tabs
  Widget _buildLevelFilterTabs() {
    final levels = [
      IeltsLevel.all,
      IeltsLevel.foundation,
      IeltsLevel.intermediate,
      IeltsLevel.advanced,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: levels.map((level) {
          final isSelected = _selectedLevel == level;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedLevel = level;
                  });
                },
                borderRadius: BorderRadius.circular(6),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected ? _skill.primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected ? _skill.primaryColor : const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (level != IeltsLevel.all) ...[
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? Colors.white : level.badgeTextColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        level.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected ? Colors.white : AppTheme.brandTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 3. Lesson Card (Tối giản chữ - Tập trung nội dung cốt lõi)
  Widget _buildLessonCard(SkillLesson lesson) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => _showLessonDetailBottomSheet(lesson),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tag Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _skill.lightBgColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            lesson.lessonNumber,
                            style: TextStyle(
                              color: _skill.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          lesson.topicTag,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    // IELTS Band Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: lesson.level.badgeBgColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        lesson.bandText,
                        style: TextStyle(
                          color: lesson.level.badgeTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Title (Rõ ràng, tinh gọn)
                Text(
                  lesson.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandTextPrimary,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 10),

                // Bottom Meta & Action (Đã lược bỏ hoàn toàn đoạn mô tả và đường divider gây rối)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, size: 13, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 3),
                        Text(
                          '${lesson.durationMinutes}p',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.quiz_outlined, size: 13, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 3),
                        Text(
                          '${lesson.exerciseCount} câu',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                    // Status Action
                    if (lesson.isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_rounded, size: 12, color: Color(0xFF16A34A)),
                            SizedBox(width: 4),
                            Text(
                              'Đã xong',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF16A34A),
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (lesson.progress > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _skill.lightBgColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Đang học ${(lesson.progress * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _skill.primaryColor,
                          ),
                        ),
                      )
                    else
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Luyện ngay',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: _skill.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(Icons.arrow_forward_ios_rounded, size: 10, color: _skill.primaryColor),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 4. Empty State
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.folder_open_rounded, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text(
              'Chưa có bài học cho cấp độ này',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppTheme.brandTextPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Vui lòng chọn cấp độ khác hoặc bấm "Tất cả".',
              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }

  // 5. Lesson Detail Bottom Sheet
  void _showLessonDetailBottomSheet(SkillLesson lesson) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Pill
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Header tags
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _skill.lightBgColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${_skill.nameVi} • ${lesson.lessonNumber}',
                            style: TextStyle(
                              color: _skill.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: lesson.level.badgeBgColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            lesson.bandText,
                            style: TextStyle(
                              color: lesson.level.badgeTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(sheetContext),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Title
                Text(
                  lesson.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandTextPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  lesson.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4B5563),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // Meta Info Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildModalMetaItem(
                        icon: Icons.timer_outlined,
                        label: 'Thời lượng',
                        value: '${lesson.durationMinutes} phút',
                      ),
                      Container(height: 28, width: 1, color: const Color(0xFFE5E7EB)),
                      _buildModalMetaItem(
                        icon: Icons.checklist_rounded,
                        label: 'Bài tập',
                        value: '${lesson.exerciseCount} câu hỏi',
                      ),
                      Container(height: 28, width: 1, color: const Color(0xFFE5E7EB)),
                      _buildModalMetaItem(
                        icon: Icons.label_outline_rounded,
                        label: 'Dạng bài',
                        value: lesson.topicTag,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Learning Outcomes
                if (lesson.keyOutcomes.isNotEmpty) ...[
                  const Text(
                    'Mục tiêu bài học:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                      color: AppTheme.brandTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...lesson.keyOutcomes.map(
                    (outcome) => Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle_rounded, size: 16, color: _skill.primaryColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              outcome,
                              style: const TextStyle(fontSize: 12.5, color: Color(0xFF374151), height: 1.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Action Button
                SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      if (_skill == SkillType.listening) {
                        final test = ListeningMockData.allTests.first;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListeningTestScreen(test: test),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('🚀 Bắt đầu bài học: ${lesson.title}'),
                            backgroundColor: _skill.primaryColor,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _skill.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Bắt đầu luyện tập ngay',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalMetaItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 18, color: _skill.primaryColor),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppTheme.brandTextPrimary,
          ),
        ),
      ],
    );
  }

  // Listening Mode Selector Tabs (Đề thi, Dictation, IPA)
  Widget _buildListeningModeSelector() {
    final modes = [
      {'title': 'Đề thi Cambridge', 'icon': Icons.headphones_rounded},
      {'title': 'Chép chính tả', 'icon': Icons.keyboard_alt_outlined},
      {'title': 'Luyện âm IPA', 'icon': Icons.record_voice_over_outlined},
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: modes.asMap().entries.map((entry) {
          final idx = entry.key;
          final mode = entry.value;
          final isSelected = _listeningModeIndex == idx;

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _listeningModeIndex = idx),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          )
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      mode['icon'] as IconData,
                      size: 16,
                      color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF64748B),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mode['title'] as String,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Dictation Exercises List View
  Widget _buildDictationSection() {
    const exercises = ListeningMockData.dictationExercises;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Bài luyện Chép chính tả (Dictation)',
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: AppTheme.brandTextPrimary),
            ),
            Text(
              '${exercises.length} chủ đề',
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: exercises.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (ctx, idx) {
            final ex = exercises[idx];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          ex.bandLevel,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded, size: 13, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 3),
                          Text('${ex.durationMinutes}p', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          const SizedBox(width: 8),
                          const Icon(Icons.list_alt_rounded, size: 13, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 3),
                          Text('${ex.sentences.length} câu', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ex.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Chủ đề: ${ex.sourceTopic}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 38,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListeningDictationScreen(exercise: ex),
                          ),
                        );
                      },
                      icon: const Icon(Icons.keyboard_alt_outlined, size: 16),
                      label: const Text('Bắt đầu chép chính tả', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // Minimal Pairs IPA List View
  Widget _buildIpaSection() {
    const categories = ListeningMockData.ipaCategories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hub Banner Button
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ListeningIpaScreen()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: const Icon(Icons.record_voice_over_rounded, color: Color(0xFF059669), size: 22),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trung Tâm Luyện Âm IPA',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.brandTextPrimary),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Toàn bộ 42 cặp âm & 407 câu luyện · Giọng UK/US',
                        style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Danh sách cặp âm tiêu biểu',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.brandTextPrimary),
            ),
            Text(
              '${categories.length} cặp',
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (ctx, idx) {
            final cat = categories[idx];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: Text(
                          cat.soundPairTitle,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        cat.wordPairLabel,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      const Spacer(),
                      Text(
                        '${cat.questions.length} câu',
                        style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cat.description,
                    style: const TextStyle(fontSize: 12.5, color: Color(0xFF334155), height: 1.35),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 38,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListeningIpaScreen(initialSoundPairId: cat.id),
                          ),
                        );
                      },
                      icon: const Icon(Icons.record_voice_over_outlined, size: 16),
                      label: const Text('Luyện phản xạ cặp âm này', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
