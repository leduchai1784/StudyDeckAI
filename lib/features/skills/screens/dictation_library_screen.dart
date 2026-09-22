import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../data/listening_mock_data.dart';
import '../models/dictation_model.dart';
import 'listening_dictation_screen.dart';

class DictationLibraryScreen extends StatefulWidget {
  const DictationLibraryScreen({super.key});

  @override
  State<DictationLibraryScreen> createState() => _DictationLibraryScreenState();
}

class _DictationLibraryScreenState extends State<DictationLibraryScreen> {
  int _selectedTabIndex = 0;
  String _searchQuery = '';

  final List<Map<String, String>> _categories = [
    {'key': 'all', 'label': 'Tất cả'},
    {'key': 'ielts_speaking', 'label': 'IELTS'},
    {'key': 'ted_ed', 'label': 'TED-Ed'},
    {'key': 'bbc_english', 'label': 'BBC 6-Min'},
    {'key': 'easy_english', 'label': 'Giao tiếp'},
  ];

  @override
  Widget build(BuildContext context) {
    const allExercises = ListeningMockData.dictationExercises;
    final selectedKey = _categories[_selectedTabIndex]['key']!;

    List<DictationExercise> displayed = allExercises;

    // Filter by Category
    if (selectedKey != 'all') {
      displayed = allExercises.where((e) => e.category == selectedKey).toList();
    }

    // Filter by Search Query
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      displayed = displayed.where((e) {
        return e.title.toLowerCase().contains(q) ||
            e.sourceTopic.toLowerCase().contains(q);
      }).toList();
    }

    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppTheme.brandTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chép Chính Tả',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
            color: AppTheme.brandTextPrimary,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppTheme.brandPrimary.withValues(alpha: 0.2)),
            ),
            child: Text(
              '${allExercises.length} bài',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.brandPrimary,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Search Bar
            TextField(
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm bài nghe...',
                hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 19),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                filled: true,
                fillColor: Colors.white,
                isDense: true,
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
            const SizedBox(height: 12),

            // 2. Category Tabs (Scrollable Horizontal)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_categories.length, (idx) {
                  final isSelected = _selectedTabIndex == idx;
                  final item = _categories[idx];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(item['label']!),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedTabIndex = idx),
                      selectedColor: AppTheme.brandPrimary,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : const Color(0xFF475569),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isSelected ? AppTheme.brandPrimary : const Color(0xFFE2E8F0),
                        ),
                      ),
                      showCheckmark: false,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 14),

            // 3. Section Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Danh sách bài học (${displayed.length})',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandTextSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 4. Exercise Cards List
            if (displayed.isEmpty)
              Container(
                padding: const EdgeInsets.all(36),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const Icon(Icons.search_off_rounded, size: 40, color: Color(0xFF94A3B8)),
                    const SizedBox(height: 8),
                    Text(
                      'Không tìm thấy bài nghe "$_searchQuery"',
                      style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayed.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = displayed[index];
                  return _buildExerciseCard(item);
                },
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(DictationExercise exercise) {
    Color badgeColor = const Color(0xFFEEF2FF);
    Color badgeTextColor = AppTheme.brandPrimary;
    String categoryName = 'IELTS';

    if (exercise.category == 'ted_ed') {
      badgeColor = const Color(0xFFFEE2E2);
      badgeTextColor = const Color(0xFFDC2626);
      categoryName = 'TED-ED';
    } else if (exercise.category == 'bbc_english') {
      badgeColor = const Color(0xFFFEF3C7);
      badgeTextColor = const Color(0xFFD97706);
      categoryName = 'BBC';
    } else if (exercise.category == 'easy_english') {
      badgeColor = const Color(0xFFDCFCE7);
      badgeTextColor = const Color(0xFF16A34A);
      categoryName = 'GIAO TIẾP';
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListeningDictationScreen(exercise: exercise),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Badges & Stats
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        categoryName,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: badgeTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        exercise.bandLevel,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${exercise.sentences.length} câu • ~${exercise.durationMinutes}p',
                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Title
                Text(
                  exercise.title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),

                // Bottom Row: Topic & Action
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.tag_rounded, size: 13, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              exercise.sourceTopic,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.brandPrimary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow_rounded, size: 14, color: Colors.white),
                          SizedBox(width: 2),
                          Text(
                            'Luyện tập',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
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
}
