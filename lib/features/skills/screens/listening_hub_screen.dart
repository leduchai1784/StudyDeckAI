import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../models/listening_test_model.dart';
import '../data/listening_mock_data.dart';
import 'listening_test_screen.dart';
import 'dictation_library_screen.dart';
import 'listening_ipa_screen.dart';
import 'listening_library_archives_screen.dart';

class ListeningHubScreen extends StatefulWidget {
  const ListeningHubScreen({super.key});

  @override
  State<ListeningHubScreen> createState() => _ListeningHubScreenState();
}

class _ListeningHubScreenState extends State<ListeningHubScreen> {
  int _selectedFilterIndex = 0; // 0: Tất cả, 1: Cam 20, 2: Cam 19, 3: Cam 18, 4: Band 5.0-6.5, 5: Band 6.5-7.5, 6: Band 7.0-8.5

  final List<String> _filters = [
    'Tất cả đề',
    'Cambridge 20',
    'Cambridge 19',
    'Cambridge 18',
    'Band 5.0 - 6.5',
    'Band 6.5 - 7.5',
    'Band 7.0 - 8.5',
  ];

  @override
  Widget build(BuildContext context) {
    const allTests = ListeningMockData.allTests;
    List<ListeningTest> displayedTests = allTests;

    if (_selectedFilterIndex == 1) {
      displayedTests = allTests.where((t) => t.id.contains('cam20')).toList();
    } else if (_selectedFilterIndex == 2) {
      displayedTests = allTests.where((t) => t.id.contains('cam19')).toList();
    } else if (_selectedFilterIndex == 3) {
      displayedTests = allTests.where((t) => t.id.contains('cam18')).toList();
    } else if (_selectedFilterIndex == 4) {
      displayedTests = allTests.where((t) => t.bandTarget.contains('5.0') || t.bandTarget.contains('5.5') || t.bandTarget.contains('6.0') || t.bandTarget.contains('6.5')).toList();
    } else if (_selectedFilterIndex == 5) {
      displayedTests = allTests.where((t) => t.bandTarget.contains('6.5') || t.bandTarget.contains('7.0') || t.bandTarget.contains('7.5')).toList();
    } else if (_selectedFilterIndex == 6) {
      displayedTests = allTests.where((t) => t.bandTarget.contains('7.0') || t.bandTarget.contains('7.5') || t.bandTarget.contains('8.0') || t.bandTarget.contains('8.5')).toList();
    }

    if (displayedTests.isEmpty) {
      displayedTests = allTests;
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
          'Luyện Nghe IELTS',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.brandTextPrimary),
        ),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.tintIndigoBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.brandPrimary.withValues(alpha: 0.2)),
            ),
            child: const Row(
              children: [
                Icon(Icons.headphones_rounded, size: 15, color: AppTheme.brandPrimary),
                SizedBox(width: 5),
                Text(
                  '48 Đề Cam',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.brandPrimary),
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
            // 1. Luyện tập bổ trợ kỹ năng (Dictation, IPA & Kho Lưu Trữ Thư Viện)
            _buildDailyTrainingSection(),
            const SizedBox(height: 22),

            // 2. Section Title & Filter Chips (Ngân Hàng Đề Thi Cambridge)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.menu_book_rounded, size: 18, color: AppTheme.brandPrimary),
                    SizedBox(width: 6),
                    Text(
                      'Ngân Hàng Đề Thi Cambridge',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brandTextPrimary,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${displayedTests.length} đề thi',
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppTheme.brandTextSecondary),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Filter Chips Scrollable
            _buildFilterChips(),
            const SizedBox(height: 16),

            // 3. Cambridge Test Cards List
            ...displayedTests.map((test) => _buildCambridgeTestCard(test)),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Filter Chips (Chuẩn StudyDeck Design System)
  Widget _buildFilterChips() {
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.brandPrimary : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? AppTheme.brandPrimary : const Color(0xFFE2E8F0),
                  width: 1.0,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF475569),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 3. Cambridge Test Card (Chuẩn Flat Card Design System - radius 12px)
  Widget _buildCambridgeTestCard(ListeningTest test) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Tag & Stats
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFF86EFAC)),
                ),
                child: const Text(
                  'THI THẬT',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFC7D2FE)),
                ),
                child: Text(
                  test.bandTarget,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5)),
                ),
              ),
              const Spacer(),
              const Icon(Icons.headphones_outlined, size: 14, color: Color(0xFF64748B)),
              const SizedBox(width: 4),
              Text(
                switch (test.id) {
                  'cam20_test1' => '54.8k lượt làm',
                  'cam20_test2' => '41.2k lượt làm',
                  'cam20_test3' => '36.5k lượt làm',
                  'cam20_test4' => '29.1k lượt làm',
                  'cam19_test1' => '48.3k lượt làm',
                  'cam19_test2' => '45.2k lượt làm',
                  'cam19_test3' => '39.7k lượt làm',
                  'cam19_test4' => '33.4k lượt làm',
                  'cam18_test1' => '62.0k lượt làm',
                  'cam18_test2' => '58.4k lượt làm',
                  _ => '42.0k lượt làm',
                },
                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Title
          Text(
            test.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.brandTextPrimary,
            ),
          ),
          if (test.subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              test.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
          ],
          const SizedBox(height: 14),

          // 2 DIRECT ACTION BUTTONS: [Luyện tập] & [Thi thật]
          Row(
            children: [
              // 📖 Luyện tập button -> Opens Part Selector Sheet
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showPartSelectorSheet(test),
                  icon: const Icon(Icons.edit_note_rounded, size: 16, color: AppTheme.brandPrimary),
                  label: const Text(
                    'Luyện tập',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.brandPrimary),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFC7D2FE), width: 1.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // ⏱️ Thi thật button -> Opens 30-min exam mode
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListeningTestScreen(
                          test: test,
                          isRealTest: true,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.timer_outlined, size: 16, color: Colors.white),
                  label: const Text(
                    'Thi thật (30p)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.brandPrimary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Part Selector Bottom Sheet for "Luyện tập" mode
  void _showPartSelectorSheet(ListeningTest test) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chọn phần luyện tập',
                        style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold, color: AppTheme.brandTextPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        test.title,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20, color: Color(0xFF64748B)),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Option: Làm Full Test
              _buildPartSelectorOption(
                title: 'Toàn bộ bài nghe (Full Test)',
                subtitle: 'Luyện tập đầy đủ 4 Parts · ${test.totalQuestions} câu hỏi',
                icon: Icons.all_inclusive_rounded,
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListeningTestScreen(
                        test: test,
                        isRealTest: false,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),

              // Options for individual parts
              ...test.sections.map((sec) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _buildPartSelectorOption(
                    title: 'Part ${sec.partNumber}: ${sec.sectionTitle.replaceAll('Part ${sec.partNumber}: ', '')}',
                    subtitle: '${sec.questions.length} câu hỏi · Nghe tự do không tính giờ',
                    icon: Icons.headphones_rounded,
                    onTap: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListeningTestScreen(
                            test: test,
                            targetPartNumber: sec.partNumber,
                            isRealTest: false,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPartSelectorOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 18, color: AppTheme.brandPrimary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppTheme.brandTextPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 4. Bài tập bổ trợ kỹ năng (Dictation & IPA)
  Widget _buildDailyTrainingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.bolt_rounded, size: 18, color: AppTheme.brandPrimary),
            SizedBox(width: 6),
            Text(
              'Luyện Tập Bổ Trợ Kỹ Năng',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
                color: AppTheme.brandTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Banner 1: Chép chính tả Dictation
        _buildQuickBannerItem(
          icon: Icons.keyboard_alt_outlined,
          iconBgColor: const Color(0xFFEEF2FF),
          iconColor: const Color(0xFF4F46E5),
          badgeText: 'DICTATION · YOUTUBE & AUDIO',
          badgeBgColor: const Color(0xFFEEF2FF),
          badgeTextColor: const Color(0xFF4338CA),
          badgeBorderColor: const Color(0xFFC7D2FE),
          title: 'Luyện Chép Chính Tả (Dictation)',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DictationLibraryScreen()),
            );
          },
        ),
        const SizedBox(height: 10),

        // Banner 2: Luyện âm IPA Minimal Pairs
        _buildQuickBannerItem(
          icon: Icons.record_voice_over_outlined,
          iconBgColor: const Color(0xFFECFDF5),
          iconColor: const Color(0xFF059669),
          badgeText: 'MINIMAL PAIRS · 42 CẶP ÂM',
          badgeBgColor: const Color(0xFFDCFCE7),
          badgeTextColor: const Color(0xFF166534),
          badgeBorderColor: const Color(0xFF86EFAC),
          title: 'Luyện Tai Phân Biệt Âm IPA',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ListeningIpaScreen()),
            );
          },
        ),
        const SizedBox(height: 10),

        // Banner 3: Kho Lưu Trữ Thư Viện (Library Archives)
        _buildQuickBannerItem(
          icon: Icons.collections_bookmark_rounded,
          iconBgColor: const Color(0xFFF5F3FF),
          iconColor: const Color(0xFF7C3AED),
          badgeText: 'CAMBRIDGE 16 - 20 · ĐẦY ĐỦ TEST 1-4',
          badgeBgColor: const Color(0xFFEDE9FE),
          badgeTextColor: const Color(0xFF6D28D9),
          badgeBorderColor: const Color(0xFFDDD6FE),
          title: 'Kho Lưu Trữ Thư Viện (Library Archives)',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ListeningLibraryArchivesScreen()),
            );
          },
        ),
      ],
    );
  }

  // Thẻ Luyện tập bổ trợ (Chuẩn Flat Card Design - border #E2E8F0, radius-md 12px)
  Widget _buildQuickBannerItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String badgeText,
    required Color badgeBgColor,
    required Color badgeTextColor,
    Color? badgeBorderColor,
    required String title,
    String? description,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: iconColor.withValues(alpha: 0.2)),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: badgeBgColor,
                          borderRadius: BorderRadius.circular(4),
                          border: badgeBorderColor != null ? Border.all(color: badgeBorderColor) : null,
                        ),
                        child: Text(
                          badgeText,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            color: badgeTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.brandTextPrimary,
                        ),
                      ),
                      if (description != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
