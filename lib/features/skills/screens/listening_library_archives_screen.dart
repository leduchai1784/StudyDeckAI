import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../models/archive_model.dart';
import '../data/listening_mock_data.dart';
import 'archive_cambridge_tests_screen.dart';
import 'archive_lessons_list_screen.dart';

class ListeningLibraryArchivesScreen extends StatefulWidget {
  const ListeningLibraryArchivesScreen({super.key});

  @override
  State<ListeningLibraryArchivesScreen> createState() => _ListeningLibraryArchivesScreenState();
}

class _ListeningLibraryArchivesScreenState extends State<ListeningLibraryArchivesScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 0; // 0: Tất cả, 1: Cambridge, 2: Spelling, 3: Numbers, 4: Pronunciation, 5: Conversations

  final List<String> _filters = [
    'TẤT CẢ',
    'CAMBRIDGE',
    'SPELLING',
    'NUMBERS',
    'PRONUNCIATION',
    'CONVERSATIONS',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const allGroups = ListeningMockData.libraryArchiveGroups;
    final query = _searchController.text.trim().toLowerCase();

    // 1. Lọc theo Category Chip
    List<ArchiveGroup> filteredGroups = allGroups;
    if (_selectedFilterIndex == 1) {
      filteredGroups = allGroups.where((g) => g.category == ArchiveCategoryType.cambridge).toList();
    } else if (_selectedFilterIndex == 2) {
      filteredGroups = allGroups.where((g) => g.category == ArchiveCategoryType.spelling).toList();
    } else if (_selectedFilterIndex == 3) {
      filteredGroups = allGroups.where((g) => g.category == ArchiveCategoryType.numbers).toList();
    } else if (_selectedFilterIndex == 4) {
      filteredGroups = allGroups.where((g) => g.category == ArchiveCategoryType.pronunciation).toList();
    } else if (_selectedFilterIndex == 5) {
      filteredGroups = allGroups.where((g) => g.category == ArchiveCategoryType.conversations).toList();
    }

    // 2. Lọc theo Query tìm kiếm
    if (query.isNotEmpty) {
      filteredGroups = filteredGroups.where((g) {
        final matchGroupTitle = g.title.toLowerCase().contains(query);
        final matchLesson = g.subSections.any((sub) => sub.lessons.any((l) =>
            l.lessonName.toLowerCase().contains(query) ||
            (l.topicDescription?.toLowerCase().contains(query) ?? false)));
        return matchGroupTitle || matchLesson;
      }).toList();
    }

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
        title: const Text(
          'Library Archives',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppTheme.brandTextPrimary,
            letterSpacing: -0.2,
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
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.collections_bookmark_rounded, size: 13, color: Color(0xFF475569)),
                SizedBox(width: 4),
                Text(
                  'Kho Bài Nghe',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Chips Bar (TẤT CẢ, CAMBRIDGE, SPELLING, NUMBERS, PRONUNCIATION, CONVERSATIONS)
            _buildCategoryFilterChips(),
            const SizedBox(height: 12),

            // Search Bar: Tìm bài nghe (VD: Cam 20, Spelling)...
            _buildSearchBar(),
            const SizedBox(height: 16),

            // Danh sách các nhóm thẻ chuyển màn hình (Không dropdown)
            if (filteredGroups.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.search_off_rounded, size: 40, color: Color(0xFF94A3B8)),
                    SizedBox(height: 10),
                    Text(
                      'Không tìm thấy bài nghe nào trong thư viện',
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              )
            else
              ...filteredGroups.map((group) => _buildArchiveGroupNavigationCard(group)),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Category Filter Chips (TẤT CẢ, CAMBRIDGE, SPELLING, NUMBERS, PRONUNCIATION, CONVERSATIONS)
  Widget _buildCategoryFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.asMap().entries.map((entry) {
          final idx = entry.key;
          final label = entry.value;
          final isSelected = _selectedFilterIndex == idx;

          return GestureDetector(
            onTap: () => setState(() => _selectedFilterIndex = idx),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7.5),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
                  width: 1.0,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                  color: isSelected ? Colors.white : const Color(0xFF475569),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Search Bar: Tìm bài nghe (VD: Cam 20, Spelling)...
  Widget _buildSearchBar() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(fontSize: 13, color: AppTheme.brandTextPrimary),
        decoration: InputDecoration(
          hintText: 'Tìm bài nghe (VD: Cam 20, Spelling)...',
          hintStyle: const TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
          prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF94A3B8)),
          suffixIcon: _searchController.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  child: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF94A3B8)),
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 11),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // Thẻ nhóm chuyển màn hình (Không dropdown, có mũi tên chuyển tiếp)
  Widget _buildArchiveGroupNavigationCard(ArchiveGroup group) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            // Phân luồng điều hướng:
            // 1. Nếu là Cambridge (có nhiều Test) -> Chuyển sang màn hình danh sách Test
            if (group.category == ArchiveCategoryType.cambridge) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArchiveCambridgeTestsScreen(group: group),
                ),
              );
            } else {
              // 2. Nếu là Chuyên đề kỹ năng (Spelling, Numbers, Pronunciation, Conversations)
              // -> Chuyển thẳng sang màn hình danh sách bài luyện để làm luôn (giảm màn đi!)
              final allLessons = group.subSections.expand((sub) => sub.lessons).toList();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArchiveLessonsListScreen(
                    title: group.title,
                    subtitle: group.badgeText,
                    lessons: allLessons,
                    isCambridgeTest: false,
                  ),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Book Tag Icon/Square (IELTS 20, A-Z, #123...)
                Container(
                  width: 44,
                  height: 48,
                  decoration: BoxDecoration(
                    color: group.tagBgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: group.tagTextColor.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        group.category == ArchiveCategoryType.cambridge ? 'IELTS' : 'SKILL',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold,
                          color: group.tagTextColor.withValues(alpha: 0.8),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        group.tagNumber,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: group.tagTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Title & Badge Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            group.title,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.brandTextPrimary,
                              letterSpacing: -0.2,
                            ),
                          ),
                          if (group.isActive) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'ACTIVE',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF166534),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(Icons.menu_book_outlined, size: 12, color: Color(0xFF64748B)),
                          const SizedBox(width: 4),
                          Text(
                            group.badgeText,
                            style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Mũi tên điều hướng sang màn hình tiếp theo
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
