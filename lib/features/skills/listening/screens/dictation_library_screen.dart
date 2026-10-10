import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../data/listening_mock_data.dart';
import '../data/dictation_archive_repository.dart';
import '../models/dictation_model.dart';
import 'listening_dictation_screen.dart';
import '../../../../shared/widgets/app_back_button.dart';

class DictationLibraryScreen extends StatefulWidget {
  const DictationLibraryScreen({super.key});

  @override
  State<DictationLibraryScreen> createState() => _DictationLibraryScreenState();
}

class _DictationLibraryScreenState extends State<DictationLibraryScreen> {
  int _selectedTabIndex = 0;
  String _searchQuery = '';
  String _selectedSort = 'recommended'; // recommended, shortest, band_asc, band_desc
  String _selectedSortLabel = 'Gợi ý nhất';
  String? _selectedBandFilter;

  List<DictationExercise> _allExercises = [];
  bool _isLoading = true;

  final List<Map<String, String>> _categories = [
    {'key': 'all', 'label': 'Tất cả'},
    {'key': 'conversations', 'label': 'Hội thoại'},
    {'key': 'ielts_speaking', 'label': 'IELTS'},
    {'key': 'ted_ed', 'label': 'TED-Ed'},
    {'key': 'bbc_english', 'label': 'BBC 6-Min'},
    {'key': 'easy_english', 'label': 'Đời sống'},
    {'key': 'kurzgesagt', 'label': 'Khoa học'},
  ];

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    try {
      await DictationArchiveRepository.ensureLoaded();
      final repoList = DictationArchiveRepository.allExercises;
      final seen = <String>{};
      final combined = <DictationExercise>[];
      for (final ex in repoList) {
        if (!seen.contains(ex.id)) {
          seen.add(ex.id);
          combined.add(ex);
        }
      }
      for (final ex in ListeningMockData.dictationExercises) {
        if (!seen.contains(ex.id)) {
          seen.add(ex.id);
          combined.add(ex);
        }
      }
      if (mounted) {
        setState(() {
          _allExercises = combined;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _allExercises = ListeningMockData.dictationExercises;
          _isLoading = false;
        });
      }
    }
  }

  String _getDisplayTitle(DictationExercise ex) {
    return ex.title
        .replaceAll('IELTS: ', '')
        .replaceAll('TED-Ed: ', '')
        .replaceAll('BBC: ', '')
        .replaceAll('Giao Tiếp: ', '')
        .replaceAll('Khoa Học: ', '')
        .replaceAll('PreF: ', '')
        .replaceAll('TED Talk: ', '');
  }

  String _getTagText(DictationExercise ex) {
    if (ex.sourceTopic.isNotEmpty) return ex.sourceTopic;
    return 'Luyện nghe phản xạ';
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) {
        final sortOptions = [
          {'key': 'recommended', 'label': 'Gợi ý nhất'},
          {'key': 'shortest', 'label': 'Thời lượng ngắn nhất'},
          {'key': 'band_asc', 'label': 'Band điểm tăng dần'},
          {'key': 'band_desc', 'label': 'Band điểm giảm dần'},
        ];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Text(
                    'Sắp xếp danh sách',
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
                const Divider(height: 16),
                ...sortOptions.map((opt) {
                  final isSelected = _selectedSort == opt['key'];
                  return ListTile(
                    dense: true,
                    title: Text(
                      opt['label']!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppTheme.brandPrimary : const Color(0xFF1E293B),
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_rounded, color: AppTheme.brandPrimary, size: 20)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedSort = opt['key']!;
                        _selectedSortLabel = opt['label']!;
                      });
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) {
        final bands = ['Tất cả band', 'Band 4.0 - 5.5', 'Band 5.5 - 7.0', 'Band 6.0 - 7.5', 'Band 6.5 - 8.0'];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Bộ lọc nâng cao',
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() => _selectedBandFilter = null);
                        Navigator.pop(ctx);
                      },
                      child: const Text('Đặt lại'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Chọn Band điểm mục tiêu',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: bands.map((b) {
                    final isAll = b == 'Tất cả band';
                    final isSelected = isAll ? (_selectedBandFilter == null) : (_selectedBandFilter == b);
                    return ChoiceChip(
                      label: Text(b),
                      selected: isSelected,
                      selectedColor: AppTheme.brandPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF334155),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 12,
                      ),
                      onSelected: (_) {
                        setState(() {
                          _selectedBandFilter = isAll ? null : b;
                        });
                        Navigator.pop(ctx);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: const AppBackButton(),
          centerTitle: true,
          title: const Text(
            'Chép Chính Tả',
            style: TextStyle(
              fontSize: 17.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final selectedKey = _categories[_selectedTabIndex]['key']!;
    List<DictationExercise> displayed = _allExercises;

    // Filter by Category
    if (selectedKey != 'all') {
      displayed = _allExercises.where((e) => e.category == selectedKey).toList();
    }

    // Filter by Band if set
    if (_selectedBandFilter != null) {
      displayed = displayed.where((e) => e.bandLevel.contains(_selectedBandFilter!)).toList();
    }

    // Filter by Search Query
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      displayed = displayed.where((e) {
        return e.title.toLowerCase().contains(q) ||
            e.sourceTopic.toLowerCase().contains(q) ||
            _getTagText(e).toLowerCase().contains(q) ||
            e.bandLevel.toLowerCase().contains(q);
      }).toList();
    }

    // Sorting
    if (_selectedSort == 'shortest') {
      displayed.sort((a, b) => a.durationMinutes.compareTo(b.durationMinutes));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const AppBackButton(),
        centerTitle: true,
        title: const Text(
          'Chép Chính Tả',
          style: TextStyle(
            fontSize: 17.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.filter_alt_outlined,
                  size: 19,
                  color: Color(0xFF475569),
                ),
                onPressed: _showFilterBottomSheet,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Search Bar with Mic & Search Icon (Form vuông bo 8px)
            Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
                style: const TextStyle(fontSize: 13.5, color: Color(0xFF0F172A)),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                  hintText: 'Tìm theo chủ đề, band điểm...',
                  hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Color(0xFF6366F1),
                    size: 21,
                  ),
                  suffixIcon: Icon(
                    Icons.mic_none_rounded,
                    color: Color(0xFF94A3B8),
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // 2. Category Tabs (Form vuông bo 8px)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_categories.length, (idx) {
                  final isSelected = _selectedTabIndex == idx;
                  final item = _categories[idx];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTabIndex = idx),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7.5),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.brandPrimary : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? AppTheme.brandPrimary : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Text(
                          item['label']!,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            color: isSelected ? Colors.white : const Color(0xFF475569),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 18),

            // 3. Section Title & Sort Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Danh sách bài học',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${displayed.length}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.brandPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: _showSortBottomSheet,
                  child: Row(
                    children: [
                      Text(
                        _selectedSortLabel,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: Color(0xFF64748B),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 4. Exercise Cards List (Form vuông bo 12px)
            if (displayed.isEmpty)
              Container(
                padding: const EdgeInsets.all(36),
                alignment: Alignment.center,
                child: const Column(
                  children: [
                    Icon(Icons.search_off_rounded, size: 40, color: Color(0xFF94A3B8)),
                    SizedBox(height: 8),
                    Text(
                      'Không tìm thấy bài nghe phù hợp',
                      style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
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
                  final item = displayed[index];
                  return _buildExerciseCard(item);
                },
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(DictationExercise exercise) {
    Color badgeColor = const Color(0xFFEEF2FF);
    Color badgeTextColor = const Color(0xFF4F46E5);
    String categoryName = 'IELTS';

    if (exercise.category == 'conversations') {
      badgeColor = const Color(0xFFE0F2FE);
      badgeTextColor = const Color(0xFF0369A1);
      categoryName = 'HỘI THOẠI';
    } else if (exercise.category == 'ted_ed') {
      badgeColor = const Color(0xFFFEE2E2);
      badgeTextColor = const Color(0xFFDC2626);
      categoryName = 'TED-Ed';
    } else if (exercise.category == 'bbc_english') {
      badgeColor = const Color(0xFFFEF3C7);
      badgeTextColor = const Color(0xFFD97706);
      categoryName = 'BBC 6-Min';
    } else if (exercise.category == 'easy_english') {
      badgeColor = const Color(0xFFDCFCE7);
      badgeTextColor = const Color(0xFF16A34A);
      categoryName = 'GIAO TIẾP';
    } else if (exercise.category == 'kurzgesagt') {
      badgeColor = const Color(0xFFF3E8FF);
      badgeTextColor = const Color(0xFF7E22CE);
      categoryName = 'KHOA HỌC';
    } else if (exercise.category == 'pref_listening') {
      badgeColor = const Color(0xFFE0F2FE);
      badgeTextColor = const Color(0xFF0369A1);
      categoryName = 'PRE-F';
    } else {
      badgeColor = const Color(0xFFEEF2FF);
      badgeTextColor = const Color(0xFF4F46E5);
      categoryName = 'TỔNG HỢP';
    }

    final displayTitle = _getDisplayTitle(exercise);
    final tagText = _getTagText(exercise);

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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListeningDictationScreen(exercise: exercise),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Badges & Stats
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        categoryName,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: badgeTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: exercise.difficultyTier == 'Dễ'
                            ? const Color(0xFFECFDF5)
                            : (exercise.difficultyTier == 'Vừa' ? const Color(0xFFFFFBEB) : const Color(0xFFFEF2F2)),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: exercise.difficultyTier == 'Dễ'
                              ? const Color(0xFFA7F3D0)
                              : (exercise.difficultyTier == 'Vừa' ? const Color(0xFFFDE68A) : const Color(0xFFFECACA)),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        exercise.difficultyTier,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: exercise.difficultyTier == 'Dễ'
                              ? const Color(0xFF059669)
                              : (exercise.difficultyTier == 'Vừa' ? const Color(0xFFD97706) : const Color(0xFFDC2626)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        exercise.bandLevel,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFCBD5E1), width: 0.6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.timer_outlined, size: 12, color: Color(0xFF475569)),
                          const SizedBox(width: 4),
                          Text(
                            '~${exercise.durationMinutes}p · ${exercise.totalSentences} câu',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Title
                Text(
                  displayTitle,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 12),

                // Bottom Row: Hashtag & "Luyện tập" Button (Form vuông bo 8px)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '# ',
                            style: TextStyle(
                              color: Color(0xFF6366F1),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            tagText,
                            style: const TextStyle(
                              color: Color(0xFF475569),
                              fontWeight: FontWeight.w500,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppTheme.brandPrimary,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.brandPrimary.withValues(alpha: 0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow_rounded, size: 16, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Luyện tập',
                            style: TextStyle(
                              fontSize: 12,
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
