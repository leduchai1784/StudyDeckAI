import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../services/tts_service.dart';

/// Modal BottomSheet Cài đặt học tập Flashcard toàn diện
/// Tùy biến: Trộn thẻ (Shuffle), Mặt trước EN/VI, Bật/tắt IPA, Bật/tắt Ví dụ, Giọng đọc, Tốc độ
/// Chuẩn Mobile-First & THEME_STANDARDS.md (bo đỉnh 16px, thẻ bo 8-12px)
class FlashcardSettingsBottomSheet extends StatelessWidget {
  final VoidCallback onShuffle;
  final bool isFrontVietnamese;
  final ValueChanged<bool> onChangeFrontLanguage;
  final bool showIpa;
  final ValueChanged<bool> onToggleShowIpa;
  final bool showExample;
  final ValueChanged<bool> onToggleShowExample;
  final TtsService? ttsService;
  final VoidCallback? onSampleSpeak;

  const FlashcardSettingsBottomSheet({
    super.key,
    required this.onShuffle,
    required this.isFrontVietnamese,
    required this.onChangeFrontLanguage,
    required this.showIpa,
    required this.onToggleShowIpa,
    required this.showExample,
    required this.onToggleShowExample,
    this.ttsService,
    this.onSampleSpeak,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onShuffle,
    required bool isFrontVietnamese,
    required ValueChanged<bool> onChangeFrontLanguage,
    required bool showIpa,
    required ValueChanged<bool> onToggleShowIpa,
    required bool showExample,
    required ValueChanged<bool> onToggleShowExample,
    TtsService? ttsService,
    VoidCallback? onSampleSpeak,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.brandSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        bool currentFrontVietnamese = isFrontVietnamese;
        bool currentShowIpa = showIpa;
        bool currentShowExample = showExample;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return FlashcardSettingsBottomSheet(
              onShuffle: onShuffle,
              isFrontVietnamese: currentFrontVietnamese,
              onChangeFrontLanguage: (val) {
                setModalState(() {
                  currentFrontVietnamese = val;
                });
                onChangeFrontLanguage(val);
              },
              showIpa: currentShowIpa,
              onToggleShowIpa: (val) {
                setModalState(() {
                  currentShowIpa = val;
                });
                onToggleShowIpa(val);
              },
              showExample: currentShowExample,
              onToggleShowExample: (val) {
                setModalState(() {
                  currentShowExample = val;
                });
                onToggleShowExample(val);
              },
              ttsService: ttsService,
              onSampleSpeak: onSampleSpeak,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.brandBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.tune_rounded, color: AppTheme.brandPrimary, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Cài đặt học tập Flashcard',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.brandTextPrimary,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 22, color: AppTheme.brandTextSecondary),
                      onPressed: () => Navigator.pop(context),
                      tooltip: 'Đóng',
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ==================== NHÓM 1: BỘ THẺ & HIỂN THỊ ====================
                _buildSectionTitle('TÙY CHỈNH BỘ THẺ & HIỂN THỊ'),
                const SizedBox(height: 8),

                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.brandBackground,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd), // 12px
                    border: Border.all(color: AppTheme.brandBorder),
                  ),
                  child: Column(
                    children: [
                      // 1.1 TRỘN THẺ (SHUFFLE)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppTheme.chipIndigoBg,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppTheme.brandPrimary.withValues(alpha: 0.35),
                                ),
                              ),
                              child: const Icon(
                                Icons.shuffle_rounded,
                                size: 20,
                                color: AppTheme.brandPrimary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Trộn ngẫu nhiên thẻ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.brandTextPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Xáo trộn ngẫu nhiên thứ tự các thẻ học',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.brandTextSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: onShuffle,
                              icon: const Icon(Icons.shuffle_rounded, size: 16),
                              label: const Text('Trộn ngay'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.brandPrimary,
                                side: const BorderSide(color: AppTheme.brandPrimary),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, indent: 14, endIndent: 14),

                      // 1.2 MẶT TRƯỚC THẺ (EN / VI)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.flip_to_front_rounded, size: 18, color: AppTheme.brandPrimary),
                                SizedBox(width: 8),
                                Text(
                                  'Mặt trước của thẻ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.brandTextPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Chọn ngôn ngữ ưu tiên hiển thị ở mặt trước',
                              style: TextStyle(fontSize: 12, color: AppTheme.brandTextSecondary),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildChoiceChip(
                                    title: 'Tiếng Anh (Mặc định)',
                                    isSelected: !isFrontVietnamese,
                                    onTap: () => onChangeFrontLanguage(false),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildChoiceChip(
                                    title: 'Tiếng Việt',
                                    isSelected: isFrontVietnamese,
                                    onTap: () => onChangeFrontLanguage(true),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, indent: 14, endIndent: 14),

                      // 1.3 PHIÊN ÂM IPA
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        child: Row(
                          children: [
                            const Icon(Icons.record_voice_over_outlined, size: 20, color: AppTheme.brandPrimary),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Hiển thị phiên âm IPA',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.brandTextPrimary,
                                ),
                              ),
                            ),
                            Switch.adaptive(
                              value: showIpa,
                              activeTrackColor: AppTheme.brandPrimary,
                              onChanged: onToggleShowIpa,
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, indent: 14, endIndent: 14),

                      // 1.4 CÂU VÍ DỤ
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        child: Row(
                          children: [
                            const Icon(Icons.menu_book_outlined, size: 20, color: AppTheme.brandPrimary),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Hiển thị câu ví dụ ngữ cảnh',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.brandTextPrimary,
                                ),
                              ),
                            ),
                            Switch.adaptive(
                              value: showExample,
                              activeTrackColor: AppTheme.brandPrimary,
                              onChanged: onToggleShowExample,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                if (ttsService != null) ...[
                  const SizedBox(height: 20),
                  _buildTtsSection(context),
                ],
              ],
            ),
          ),
        );
  }

  Widget _buildTtsSection(BuildContext context) {
    final tts = ttsService!;
    return ValueListenableBuilder<int>(
      valueListenable: tts.settingsVersionNotifier,
      builder: (context, _, child) {
        final currentVoice = tts.voice;
        final isAutoPlay = tts.autoPlay;
        final currentRate = tts.speechRate;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('CÀI ĐẶT PHÁT ÂM & GIỌNG ĐỌC'),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: AppTheme.brandBackground,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(color: AppTheme.brandBorder),
              ),
              child: Column(
                children: [
                  // 2.1 GIỌNG ĐỌC (UK / US)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Giọng đọc phát âm',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.brandTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildChoiceChip(
                                title: '🇬🇧 Giọng Anh (UK)',
                                isSelected: currentVoice == TtsVoice.uk,
                                onTap: () {
                                  tts.setVoice(TtsVoice.uk);
                                  onSampleSpeak?.call();
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildChoiceChip(
                                title: '🇺🇸 Giọng Mỹ (US)',
                                isSelected: currentVoice == TtsVoice.us,
                                onTap: () {
                                  tts.setVoice(TtsVoice.us);
                                  onSampleSpeak?.call();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, indent: 14, endIndent: 14),

                  // 2.2 TỰ ĐỘNG ĐỌC
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.play_circle_outline_rounded, size: 22, color: AppTheme.brandPrimary),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tự động đọc khi chuyển thẻ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.brandTextPrimary,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Phát âm từ vựng ngay khi xuất hiện',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.brandTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch.adaptive(
                          value: isAutoPlay,
                          activeTrackColor: AppTheme.brandPrimary,
                          onChanged: (val) => tts.setAutoPlay(val),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, indent: 14, endIndent: 14),

                  // 2.3 TỐC ĐỘ ĐỌC (SLIDER)
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tốc độ đọc phát âm',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.brandTextPrimary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.chipIndigoBg,
                                borderRadius: BorderRadius.circular(AppTheme.radiusXs),
                              ),
                              child: Text(
                                '${(currentRate * 2).toStringAsFixed(1)}x',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.brandPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppTheme.brandPrimary,
                            inactiveTrackColor: AppTheme.brandBorder,
                            thumbColor: AppTheme.brandPrimary,
                            overlayColor: AppTheme.brandPrimary.withValues(alpha: 0.15),
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                          ),
                          child: Slider(
                            value: currentRate.clamp(0.25, 0.8),
                            min: 0.25,
                            max: 0.8,
                            divisions: 11,
                            onChanged: (val) => tts.setSpeechRate(val),
                            onChangeEnd: (val) => onSampleSpeak?.call(),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Chậm (0.5x)', style: TextStyle(fontSize: 11, color: AppTheme.brandTextMuted)),
                              Text('Chuẩn (1.0x)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.brandPrimary)),
                              Text('Nhanh (1.6x)', style: TextStyle(fontSize: 11, color: AppTheme.brandTextMuted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: AppTheme.brandTextSecondary,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildChoiceChip({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusSm), // 8px
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.chipIndigoBg : AppTheme.brandSurface,
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          border: Border.all(
            color: isSelected ? AppTheme.brandPrimary : AppTheme.brandBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppTheme.brandPrimary : AppTheme.brandTextPrimary,
          ),
        ),
      ),
    );
  }
}
