import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import 'flashcard_mode_bottom_bar.dart';

/// Modal BottomSheet "Chế độ luyện tập" chuẩn ảnh tham khảo thực tế của người dùng
/// Mở từ đáy lên, bo góc đỉnh 16px, chứa lưới 7 phương pháp học (kèm chế độ Tổng hợp)
class FlashcardStudyModesModal extends StatefulWidget {
  final FlashcardStudyMode currentMode;
  final ValueChanged<FlashcardStudyMode> onSelectMode;

  const FlashcardStudyModesModal({
    super.key,
    required this.currentMode,
    required this.onSelectMode,
  });

  /// Hàm tiện ích mở modal nhanh từ bất kỳ đâu
  static Future<FlashcardStudyMode?> show({
    required BuildContext context,
    required FlashcardStudyMode currentMode,
    required ValueChanged<FlashcardStudyMode> onSelectMode,
  }) {
    return showModalBottomSheet<FlashcardStudyMode>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FlashcardStudyModesModal(
        currentMode: currentMode,
        onSelectMode: onSelectMode,
      ),
    );
  }

  @override
  State<FlashcardStudyModesModal> createState() => _FlashcardStudyModesModalState();
}

class _FlashcardStudyModesModalState extends State<FlashcardStudyModesModal> {
  late FlashcardStudyMode _selectedMode;

  @override
  void initState() {
    super.initState();
    _selectedMode = widget.currentMode;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.brandSurface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16), // Chuẩn THEME_STANDARDS: Modal 16px
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Drag handle
              Center(
                child: Container(
                  width: 32,
                  height: 3.5,
                  decoration: BoxDecoration(
                    color: AppTheme.brandBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // 2. Header: Tiêu đề + Nút đóng
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chế độ luyện tập',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.brandTextPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 1),
                      Text(
                        'Chọn phương pháp học bạn muốn',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppTheme.brandTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9), // Slate 100
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 15,
                        color: AppTheme.brandTextSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // 3. Grid 2 cột: 8 chế độ học đồng đều, gọn gàng và cân đối màn hình
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 8,
                mainAxisSpacing: 6,
                childAspectRatio: 1.62,
                children: FlashcardStudyMode.values.map((mode) {
                  final isSelected = _selectedMode == mode;
                  return _buildModeGridItem(mode, isSelected);
                }).toList(),
              ),
              const SizedBox(height: 10),

              // 4. Primary Button ở đáy
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSelectMode(_selectedMode);
                    Navigator.of(context).pop(_selectedMode);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.brandPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm), // 8px
                    ),
                    elevation: 0,
                    alignment: Alignment.center,
                  ),
                  child: Text(
                    'Bắt đầu với ${_selectedMode.title}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeGridItem(FlashcardStudyMode mode, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedMode = mode;
        });
      },
      borderRadius: BorderRadius.circular(AppTheme.radiusMd), // 12px
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? mode.color.withValues(alpha: 0.04)
              : AppTheme.brandSurface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: isSelected ? mode.color : AppTheme.brandBorder,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: mode.color.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top: Icon + Dấu check nếu đang chọn
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: mode.color,
                    borderRadius: BorderRadius.circular(AppTheme.radiusXs),
                  ),
                  child: Icon(
                    mode.icon,
                    color: Colors.white,
                    size: 14.5,
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: mode.color,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 11,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),

            // Tiêu đề & mô tả
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  mode.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandTextPrimary,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  mode.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9.5,
                    color: AppTheme.brandTextSecondary,
                    height: 1.15,
                  ),
                ),
              ],
            ),

            // Badge trạng thái ở đáy thẻ
            Text(
              mode.badgeText,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: isSelected ? mode.color : AppTheme.brandTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

