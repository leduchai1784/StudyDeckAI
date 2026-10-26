import 'package:flutter/material.dart';
import '../../../app/theme.dart';

/// Enum định nghĩa các chế độ luyện tập flashcard
enum FlashcardStudyMode {
  flipCard,       // Lật thẻ (SRS)
  typing,         // Gõ từ
  quiz,           // Quiz trắc nghiệm
  listening,      // Luyện nghe
  cloze,          // Điền vào chỗ trống
  pronunciation,  // Luyện phát âm AI
  cardBlast,      // Card Blast phản xạ tốc độ
  mixed,          // Tổng hợp (mỗi thẻ một chế độ ngẫu nhiên, trừ lật thẻ)
}

extension FlashcardStudyModeExt on FlashcardStudyMode {
  String get title {
    switch (this) {
      case FlashcardStudyMode.flipCard:
        return 'Lật thẻ';
      case FlashcardStudyMode.typing:
        return 'Gõ từ';
      case FlashcardStudyMode.quiz:
        return 'Quiz trắc nghiệm';
      case FlashcardStudyMode.listening:
        return 'Luyện nghe';
      case FlashcardStudyMode.cloze:
        return 'Điền vào chỗ trống';
      case FlashcardStudyMode.pronunciation:
        return 'Luyện phát âm AI';
      case FlashcardStudyMode.cardBlast:
        return 'Card Blast';
      case FlashcardStudyMode.mixed:
        return 'Tổng hợp';
    }
  }

  String get subtitle {
    switch (this) {
      case FlashcardStudyMode.flipCard:
        return 'Tự nhớ nghĩa, lật thẻ chấm điểm';
      case FlashcardStudyMode.typing:
        return 'Đọc tiếng Việt, gõ lại tiếng Anh';
      case FlashcardStudyMode.quiz:
        return 'Phản xạ nhanh 4 đáp án';
      case FlashcardStudyMode.listening:
        return 'Nghe audio và gõ chính tả';
      case FlashcardStudyMode.cloze:
        return 'Hoàn thành câu theo ngữ cảnh';
      case FlashcardStudyMode.pronunciation:
        return 'Chấm điểm IPA real-time';
      case FlashcardStudyMode.cardBlast:
        return 'Phản xạ chớp nhoáng 4 đáp án';
      case FlashcardStudyMode.mixed:
        return 'Xoay tua ngẫu nhiên các chế độ';
    }
  }

  String get shortLabel {
    switch (this) {
      case FlashcardStudyMode.flipCard:
        return 'Lật thẻ (SRS)';
      case FlashcardStudyMode.typing:
        return 'Gõ từ tiếng Anh';
      case FlashcardStudyMode.quiz:
        return 'Quiz 4 đáp án';
      case FlashcardStudyMode.listening:
        return 'Luyện nghe';
      case FlashcardStudyMode.cloze:
        return 'Điền từ';
      case FlashcardStudyMode.pronunciation:
        return 'Phát âm AI';
      case FlashcardStudyMode.cardBlast:
        return 'Card Blast';
      case FlashcardStudyMode.mixed:
        return 'Tổng hợp';
    }
  }

  IconData get icon {
    switch (this) {
      case FlashcardStudyMode.flipCard:
        return Icons.layers_rounded;
      case FlashcardStudyMode.typing:
        return Icons.keyboard_rounded;
      case FlashcardStudyMode.quiz:
        return Icons.help_outline_rounded;
      case FlashcardStudyMode.listening:
        return Icons.headphones_rounded;
      case FlashcardStudyMode.cloze:
        return Icons.edit_note_rounded;
      case FlashcardStudyMode.pronunciation:
        return Icons.mic_rounded;
      case FlashcardStudyMode.cardBlast:
        return Icons.local_fire_department_rounded;
      case FlashcardStudyMode.mixed:
        return Icons.shuffle_rounded;
    }
  }

  Color get color {
    switch (this) {
      case FlashcardStudyMode.flipCard:
        return AppTheme.brandPrimary; // Tím Indigo
      case FlashcardStudyMode.typing:
        return const Color(0xFF0D9488); // Teal
      case FlashcardStudyMode.quiz:
        return const Color(0xFFF59E0B); // Amber/Orange
      case FlashcardStudyMode.listening:
        return const Color(0xFF2563EB); // Blue
      case FlashcardStudyMode.cloze:
        return const Color(0xFF8B5CF6); // Purple Neon
      case FlashcardStudyMode.pronunciation:
        return const Color(0xFFE11D48); // Rose/Red
      case FlashcardStudyMode.cardBlast:
        return const Color(0xFFEA580C); // Orange Flame
      case FlashcardStudyMode.mixed:
        return const Color(0xFF6366F1); // Indigo sáng / Violet
    }
  }

  String get badgeText {
    switch (this) {
      case FlashcardStudyMode.flipCard:
        return 'Đang học';
      case FlashcardStudyMode.typing:
      case FlashcardStudyMode.quiz:
      case FlashcardStudyMode.listening:
        return '10/10 lượt';
      case FlashcardStudyMode.cloze:
        return 'Miễn phí';
      case FlashcardStudyMode.pronunciation:
        return 'AI Pro';
      case FlashcardStudyMode.cardBlast:
        return 'Tốc độ';
      case FlashcardStudyMode.mixed:
        return 'Đa dạng';
    }
  }
}

/// Card cố định ở đáy màn hình hiển thị chế độ đang học + nút Đổi chế độ
/// Chuẩn theo ảnh thiết kế thực tế của người dùng
class FlashcardModeBottomBar extends StatelessWidget {
  final FlashcardStudyMode currentMode;
  final FlashcardStudyMode? currentSubMode;
  final VoidCallback onChangeMode;

  const FlashcardModeBottomBar({
    super.key,
    required this.currentMode,
    this.currentSubMode,
    required this.onChangeMode,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = (currentMode == FlashcardStudyMode.mixed && currentSubMode != null)
        ? currentSubMode!.color
        : currentMode.color;
    final effectiveIcon = (currentMode == FlashcardStudyMode.mixed && currentSubMode != null)
        ? currentSubMode!.icon
        : currentMode.icon;
    final labelText = (currentMode == FlashcardStudyMode.mixed && currentSubMode != null)
        ? 'Đang học: Tổng hợp • ${currentSubMode!.shortLabel}'
        : 'Đang học: ${currentMode.shortLabel}';

    return InkWell(
      onTap: onChangeMode,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd), // 12px
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.brandSurface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: effectiveColor.withValues(alpha: 0.25),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: effectiveColor.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon chế độ trong ô vuông bo góc
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: effectiveColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm), // 8px
              ),
              child: Icon(
                effectiveIcon,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),

            // Thông tin chế độ
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Chế độ luyện tập',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brandTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    labelText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: effectiveColor,
                    ),
                  ),
                ],
              ),
            ),

            // Nút "Đổi chế độ ^"
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.brandBackground,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm), // 8px
                border: Border.all(color: AppTheme.brandBorder),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Đổi chế độ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.brandTextPrimary,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_up_rounded,
                    size: 16,
                    color: AppTheme.brandTextSecondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
