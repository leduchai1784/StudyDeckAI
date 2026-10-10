import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app/theme.dart';
import '../../../../services/tts_service.dart';
import '../models/listening_test_model.dart';
import '../data/listening_mock_data.dart';
import 'dictation_library_screen.dart';
import 'listening_ipa_screen.dart';
import '../../../../shared/widgets/app_back_button.dart';

import 'cambridge_tests_list_screen.dart';

class ListeningHubScreen extends StatefulWidget {
  const ListeningHubScreen({super.key});

  @override
  State<ListeningHubScreen> createState() => _ListeningHubScreenState();
}

class _ListeningHubScreenState extends State<ListeningHubScreen> {
  String _selectedAccent = 'en-GB'; // Default 'en-GB' or 'en-US'

  @override
  void initState() {
    super.initState();
    _loadSelectedAccent();
  }

  Future<void> _loadSelectedAccent() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('studydeck_listening_accent');
      if (saved != null && (saved == 'en-GB' || saved == 'en-US')) {
        if (mounted) setState(() => _selectedAccent = saved);
      }
    } catch (_) {}
  }

  Future<void> _setAccent(String langCode) async {
    if (_selectedAccent == langCode) return;
    setState(() => _selectedAccent = langCode);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('studydeck_listening_accent', langCode);
      await TtsService().setVoice(langCode == 'en-GB' ? TtsVoice.uk : TtsVoice.us);
    } catch (_) {}
  }
  Color _getVolumeColor(int vol) {
    switch (vol % 6) {
      case 0:
        return const Color(0xFF4F46E5); // Indigo
      case 1:
        return const Color(0xFF0D9488); // Teal
      case 2:
        return const Color(0xFF2563EB); // Blue
      case 3:
        return const Color(0xFF7C3AED); // Purple
      case 4:
        return const Color(0xFFD97706); // Amber
      case 5:
      default:
        return const Color(0xFFE11D48); // Rose
    }
  }

  Color _getVolumeBgColor(int vol) {
    switch (vol % 6) {
      case 0:
        return const Color(0xFFEEF2FF);
      case 1:
        return const Color(0xFFF0FDFA);
      case 2:
        return const Color(0xFFEFF6FF);
      case 3:
        return const Color(0xFFF5F3FF);
      case 4:
        return const Color(0xFFFFFBEB);
      case 5:
      default:
        return const Color(0xFFFFF1F2);
    }
  }

  @override
  Widget build(BuildContext context) {
    const allTests = ListeningMockData.allTests;

    // Gom nhóm các bài test theo từng tập Cambridge (10 đến 20)
    final Map<int, List<ListeningTest>> cambridgeVolumes = {};
    for (final test in allTests) {
      final m = RegExp(r'cam(\d+)').firstMatch(test.id);
      if (m != null) {
        final vol = int.parse(m.group(1)!);
        cambridgeVolumes.putIfAbsent(vol, () => []).add(test);
      }
    }
    final sortedVolumes = cambridgeVolumes.keys.toList()..sort();

    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const AppBackButton(),
        title: const Text(
          'Luyện Nghe IELTS',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppTheme.brandTextPrimary,
          ),
        ),
        actions: [
          _buildAccentSelectorHeader(),
          const SizedBox(width: 14),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. LUYỆN TẬP BỔ TRỢ Section
            _buildDailyTrainingSection(),
            const SizedBox(height: 22),

            // 2. Đề Thi Cambridge Header (Đồng bộ chuẩn phong cách với Section 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text(
                      '📖',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'ĐỀ THI CAMBRIDGE',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF475569),
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${allTests.length} Đề • ${sortedVolumes.length} Bộ (Cam 10 – 20)',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 3. Danh sách các Bộ đề Cambridge (Ấn vào mới hiện các test)
            ...sortedVolumes.map((vol) {
              final tests = cambridgeVolumes[vol] ?? [];
              return _buildCambridgeBookCard(vol, tests);
            }),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Card hiển thị cho từng bộ Cambridge (Đồng bộ 100% kích thước & typography với Training Card)
  Widget _buildCambridgeBookCard(int volume, List<ListeningTest> tests) {
    final color = _getVolumeColor(volume);
    final bgColor = _getVolumeBgColor(volume);
    final bandText = tests.isNotEmpty ? tests.first.bandTarget : 'Band 6.0 – 7.5';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CambridgeTestsListScreen(
                  volume: volume,
                  tests: tests,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Khối vuông 44x44 bo 8px đồng bộ chính xác với icon thẻ trên
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'CAM',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold,
                          color: color.withValues(alpha: 0.8),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        '$volume',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: color,
                          height: 1.05,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),

                // Tiêu đề & Dòng phụ đồng bộ tỷ lệ chữ (14.5px & 12px)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cambridge IELTS $volume',
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.brandTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${tests.length} bài test • $bandText',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                // Trailing Arrow đồng bộ 100% với thẻ trên
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 1. LUYỆN TẬP BỔ TRỢ (Form vuông bo 12px)
  Widget _buildDailyTrainingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              '⚡',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(width: 6),
            Text(
              'LUYỆN TẬP BỔ TRỢ',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Color(0xFF475569),
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Card 1: Chép chính tả
        _buildTrainingCard(
          icon: Icons.mic_none_rounded,
          iconBgColor: const Color(0xFFEEF0FF),
          iconColor: const Color(0xFF4F46E5),
          title: 'Chép chính tả',
          badgeText: 'Audio & Luyện gõ',
          badgeBgColor: const Color(0xFFEEF2FF),
          badgeTextColor: const Color(0xFF4F46E5),
          subtitle: 'Luyện phản xạ gõ & bắt từ khoá chuẩn',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DictationLibraryScreen()),
            );
          },
        ),
        const SizedBox(height: 10),

        // Card 2: Phân biệt âm IPA
        _buildTrainingCard(
          icon: Icons.volume_up_outlined,
          iconBgColor: const Color(0xFFE8F8F0),
          iconColor: const Color(0xFF059669),
          title: 'Phân biệt âm IPA',
          badgeText: '42 Cặp âm',
          badgeBgColor: const Color(0xFFECFDF5),
          badgeTextColor: const Color(0xFF059669),
          subtitle: 'Bắt chuẩn nguyên âm ngắn & phụ âm đuôi',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ListeningIpaScreen()),
            );
          },
        ),
      ],
    );
  }

  // Component Thẻ Luyện tập bổ trợ (Form vuông bo 12px)
  Widget _buildTrainingCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String badgeText,
    required Color badgeBgColor,
    required Color badgeTextColor,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Icon vuông bo 8px
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 14),

                // Tiêu đề, badge và mô tả
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.brandTextPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: badgeBgColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              badgeText,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: badgeTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                // Trailing Arrow
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccentSelectorHeader() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAccentToggleItem(label: '🇬🇧 UK', langCode: 'en-GB'),
          _buildAccentToggleItem(label: '🇺🇸 US', langCode: 'en-US'),
        ],
      ),
    );
  }

  Widget _buildAccentToggleItem({required String label, required String langCode}) {
    final isSelected = _selectedAccent == langCode;
    return GestureDetector(
      onTap: () => _setAccent(langCode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? const Color(0xFF4338CA) : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}
