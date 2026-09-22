import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../services/roadmap_progress_service.dart';
import '../../grammar/data/grammar_lessons_data.dart';
import '../../grammar/models/grammar_lesson_model.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final RoadmapProgressService _roadmapService = RoadmapProgressService();

  Set<String> _completedIds = {};
  bool _isLoading = true;
  String _searchQuery = '';
  int _selectedTabIndex = 0; // 0: Toàn Tập (25 Chủ Đề), 1: Nâng Cao Theo Band

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final completed = await _roadmapService.getAllCompletedLessonIds();

      if (mounted) {
        setState(() {
          _completedIds = completed;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final refLessons = GrammarLessonsData.getReferenceLessons()
        .where((l) =>
            _searchQuery.isEmpty ||
            l.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            l.titleVi.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            l.titleEn.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    final advLessons = GrammarLessonsData.getAdvancedLessons()
        .where((l) =>
            _searchQuery.isEmpty ||
            l.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            l.titleVi.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            l.titleEn.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Kho Khóa Học & Lộ Trình',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.brandTextPrimary,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppTheme.brandPrimary))
            : RefreshIndicator(
                onRefresh: _loadData,
                color: AppTheme.brandPrimary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search input
                      TextField(
                        onChanged: (val) => setState(() => _searchQuery = val.trim()),
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm chủ đề ngữ pháp (Word forms, Tenses...)...',
                          hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 20),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppTheme.brandPrimary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 2-Tab Selector: Toàn Tập (25 Chủ Đề) vs Nâng Cao Theo Band
                      _buildTabBar(),
                      const SizedBox(height: 16),

                      // Nội dung theo Tab được chọn
                      if (_selectedTabIndex == 0) ...[
                        // PHẦN 1: NGỮ PHÁP TOÀN TẬP (25 Chủ Đề)
                        _buildSectionHeader(
                          badgeText: 'TOÀN TẬP',
                          badgeBg: const Color(0xFFDBEAFE),
                          badgeColor: const Color(0xFF1E40AF),
                          title: 'Ngữ pháp toàn tập',
                          subtitle:
                              '25 chủ đề ngữ pháp nền tảng cho IELTS. Mỗi mục gồm lý thuyết chi tiết và bài tập trắc nghiệm giải thích từng câu.',
                        ),
                        const SizedBox(height: 12),

                        if (refLessons.isEmpty)
                          _buildEmptySearchResult()
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: refLessons.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final item = refLessons[index];
                              final isCompleted = _completedIds.contains(item.id);
                              return _buildReferenceLessonCard(index + 1, item, isCompleted);
                            },
                          ),
                      ] else ...[
                        // PHẦN 2: ADVANCED GRAMMAR (Nâng Cao Theo Band)
                        _buildSectionHeader(
                          badgeText: 'NÂNG CAO',
                          badgeBg: const Color(0xFFFCE7F3),
                          badgeColor: const Color(0xFF9D174D),
                          title: 'Advanced Grammar',
                          subtitle:
                              'Chuyên đề chuyên sâu giúp bứt phá điểm IELTS Writing & Speaking Band 7+.',
                        ),
                        const SizedBox(height: 12),

                        if (advLessons.isEmpty)
                          _buildEmptySearchResult()
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: advLessons.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = advLessons[index];
                              final isCompleted = _completedIds.contains(item.id);
                              return _buildAdvancedLessonCard(item, isCompleted);
                            },
                          ),
                      ],
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // 2-Tab Bar: Toàn Tập (25 Chủ Đề) | Nâng Cao Theo Band
  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabItem(
              title: 'Toàn Tập (25 Chủ Đề)',
              index: 0,
            ),
          ),
          Expanded(
            child: _buildTabItem(
              title: 'Nâng Cao Theo Band',
              index: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({required String title, required int index}) {
    final isSelected = _selectedTabIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedTabIndex = index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF64748B),
              ),
            ),
          ),
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF4F46E5) : Colors.transparent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(3),
                topRight: Radius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchResult() {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded, size: 40, color: Color(0xFF94A3B8)),
          const SizedBox(height: 8),
          Text(
            'Không tìm thấy chủ đề nào cho "$_searchQuery"',
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }



  // Section Header with Badge
  Widget _buildSectionHeader({
    required String badgeText,
    required Color badgeBg,
    required Color badgeColor,
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: badgeColor,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.bold,
                color: AppTheme.brandTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
            height: 1.35,
          ),
        ),
      ],
    );
  }

  // 2. Reference Lesson Card (1..25)
  Widget _buildReferenceLessonCard(int number, GrammarLessonModel item, bool isCompleted) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () async {
          await context.push('/grammar/lesson', extra: {'lessonId': item.id});
          _loadData();
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isCompleted ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            children: [
              // Circle Number (1 to 25)
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? const Color(0xFF16A34A) : const Color(0xFF475569),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brandTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.questionCount} câu hỏi • ${item.durationMinutes} phút',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              if (isCompleted) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, size: 11, color: Color(0xFF16A34A)),
                      SizedBox(width: 3),
                      Text(
                        'Đã xong',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
              ],
              const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFF94A3B8)),
            ],
          ),
        ),
      ),
    );
  }

  // 3. Advanced Lesson Card
  Widget _buildAdvancedLessonCard(GrammarLessonModel item, bool isCompleted) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () async {
          await context.push('/grammar/lesson', extra: {'lessonId': item.id});
          _loadData();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCompleted ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF2F8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.auto_awesome_rounded, color: Color(0xFFDB2777), size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.brandTextPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCE7F3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.bandText,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF9D174D),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.titleVi,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.3),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 12, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 4),
                        Text(
                          '${item.durationMinutes} phút',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.quiz_outlined, size: 12, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 4),
                        Text(
                          '${item.questionCount} câu',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                        const Spacer(),
                        const Text(
                          'Học ngay',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.brandPrimary,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: AppTheme.brandPrimary),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
