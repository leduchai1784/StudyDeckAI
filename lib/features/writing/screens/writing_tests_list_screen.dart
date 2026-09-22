import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../data/writing_mock_data.dart';
import '../models/writing_model.dart';
import 'writing_practice_screen.dart';

class WritingTestsListScreen extends StatefulWidget {
  const WritingTestsListScreen({super.key});

  @override
  State<WritingTestsListScreen> createState() => _WritingTestsListScreenState();
}

class _WritingTestsListScreenState extends State<WritingTestsListScreen> {
  int _selectedMainTab = 0; // 0: Tất cả, 1: Task 1, 2: Task 2, 3: Writing Builder
  String _selectedSubCategory = 'all';
  String _searchQuery = '';

  final List<String> _mainTabs = ['Tất cả', 'Task 1', 'Task 2', 'Writing Builder'];

  final List<Map<String, String>> _task1SubFilters = [
    {'key': 'all', 'label': 'Tất cả'},
    {'key': 'barChart', 'label': 'Bar Chart'},
    {'key': 'lineGraph', 'label': 'Line Graph'},
    {'key': 'pieChart', 'label': 'Pie Chart'},
    {'key': 'table', 'label': 'Table'},
    {'key': 'map', 'label': 'Map'},
    {'key': 'process', 'label': 'Process'},
    {'key': 'mixedGraph', 'label': 'Mixed Graph'},
  ];

  final List<Map<String, String>> _task2SubFilters = [
    {'key': 'all', 'label': 'Tất cả'},
    {'key': 'opinion', 'label': 'Opinion Essay'},
    {'key': 'discussBoth', 'label': 'Discuss Both Views'},
    {'key': 'problemSolution', 'label': 'Problem & Solution'},
    {'key': 'advantagesDisadvantages', 'label': 'Advantages & Disadvantages'},
    {'key': 'twoPart', 'label': 'Two-part Question'},
  ];

  @override
  Widget build(BuildContext context) {
    const allPrompts = WritingMockData.prompts;

    // Filter by Main Tab
    var displayed = allPrompts.where((p) {
      if (_selectedMainTab == 1) return p.taskType == WritingTaskType.task1;
      if (_selectedMainTab == 2) return p.taskType == WritingTaskType.task2;
      return true;
    }).toList();

    // Filter by Sub-Category
    if (_selectedSubCategory != 'all') {
      displayed = displayed.where((p) {
        return p.category.name == _selectedSubCategory;
      }).toList();
    }

    // Filter by Search Query
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      displayed = displayed.where((p) {
        return p.title.toLowerCase().contains(q) ||
            p.promptText.toLowerCase().contains(q) ||
            p.categoryLabel.toLowerCase().contains(q);
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
          'Thư Viện Đề Thi Writing',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
            color: AppTheme.brandTextPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Main Tab Switcher
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: List.generate(_mainTabs.length, (idx) {
                  final isSelected = _selectedMainTab == idx;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMainTab = idx;
                          _selectedSubCategory = 'all';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ]
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              _mainTabs[idx],
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? AppTheme.brandPrimary : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),

            // 2. Search Input
            TextField(
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              decoration: InputDecoration(
                hintText: 'Tìm đề thi (Traffic, Education, Remote work...)...',
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

            // 3. Sub-Filters Chips (If Task 1 or Task 2 selected)
            if (_selectedMainTab == 1 || _selectedMainTab == 2) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: (_selectedMainTab == 1 ? _task1SubFilters : _task2SubFilters).map((item) {
                    final isSelected = _selectedSubCategory == item['key'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(item['label']!),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _selectedSubCategory = item['key']!),
                        selectedColor: AppTheme.brandPrimary,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          fontSize: 12,
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
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // 4. Header with Count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Danh sách đề thi (${displayed.length})',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandTextSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 5. Test Cards List
            if (displayed.isEmpty)
              Container(
                padding: const EdgeInsets.all(36),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const Icon(Icons.menu_book_rounded, size: 40, color: Color(0xFF94A3B8)),
                    const SizedBox(height: 8),
                    Text(
                      'Không tìm thấy đề thi phù hợp với "$_searchQuery"',
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
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final prompt = displayed[index];
                  return _buildPromptCard(prompt);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromptCard(WritingPrompt prompt) {
    Color tagBg = const Color(0xFFEEF2FF);
    Color tagText = AppTheme.brandPrimary;

    if (prompt.category == WritingCategory.problemSolution) {
      tagBg = const Color(0xFFFEE2E2);
      tagText = const Color(0xFFDC2626);
    } else if (prompt.category == WritingCategory.discussBoth) {
      tagBg = const Color(0xFFF3E8FF);
      tagText = const Color(0xFF7E22CE);
    } else if (prompt.category == WritingCategory.pieChart || prompt.category == WritingCategory.map) {
      tagBg = const Color(0xFFECFDF5);
      tagText = const Color(0xFF059669);
    }

    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Category Badge & Target Band
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: tagBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    prompt.categoryLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: tagText,
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
                    prompt.taskType == WritingTaskType.task1 ? 'Task 1 (≥ 150 từ)' : 'Task 2 (≥ 250 từ)',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF475569),
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.people_outline_rounded, size: 14, color: Color(0xFF94A3B8)),
                const SizedBox(width: 3),
                Text(
                  '${(prompt.viewsCount / 1000).toStringAsFixed(1)}k lượt viết',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Title
            Text(
              prompt.title,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
                color: AppTheme.brandTextPrimary,
              ),
            ),
            const SizedBox(height: 4),

            // Prompt snippet
            Text(
              prompt.promptText,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.5,
                color: Color(0xFF475569),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 14),

            // Action Button
            Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_outlined, size: 14, color: Color(0xFF64748B)),
                    const SizedBox(width: 4),
                    Text(
                      '${prompt.timeMinutes} phút',
                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WritingPracticeScreen(prompt: prompt),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_rounded, size: 14, color: Colors.white),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Vào viết bài ➔',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.brandPrimary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
