import 'dart:math';
import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../models/edu_word.dart';

/// Thẻ học Flashcard trung tâm với hiệu ứng lật 3D mượt mà
/// Chuẩn Mobile-First & THEME_STANDARDS.md (bo 12px, viền #E2E8F0)
/// Hỗ trợ tùy chỉnh: Mặt trước EN/VI, Bật/tắt IPA, Bật/tắt Ví dụ
/// Khắc phục triệt để lỗi tràn giao diện (RenderFlex overflow) bằng Scrollable Body
class FlashcardStudyCard extends StatelessWidget {
  final EduWord word;
  final bool isStarred;
  final bool isFlipped;
  final Animation<double> flipAnimation;
  final VoidCallback onFlip;
  final VoidCallback onSpeak;
  final VoidCallback onToggleStar;
  final String? levelBadgeText;
  final bool isFrontVietnamese;
  final bool showIpa;
  final bool showExample;

  const FlashcardStudyCard({
    super.key,
    required this.word,
    required this.isStarred,
    required this.isFlipped,
    required this.flipAnimation,
    required this.onFlip,
    required this.onSpeak,
    required this.onToggleStar,
    this.levelBadgeText,
    this.isFrontVietnamese = false,
    this.showIpa = true,
    this.showExample = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: flipAnimation,
      builder: (context, child) {
        final angle = flipAnimation.value * pi;
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(angle);

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: angle >= (pi / 2)
              ? Transform(
                  transform: Matrix4.identity()..rotateY(pi),
                  alignment: Alignment.center,
                  child: _buildCardBack(context),
                )
              : _buildCardFront(context),
        );
      },
    );
  }

  // --- MẶT TRƯỚC (Front) ---
  Widget _buildCardFront(BuildContext context) {
    final badgeText = isFrontVietnamese
        ? '• Từ vựng (Tiếng Việt)'
        : (levelBadgeText ?? '• Từ vựng - ${word.level.isNotEmpty ? word.level : 'A1'}');

    final mainTitle = isFrontVietnamese
        ? (word.viword.isNotEmpty ? word.viword : word.title)
        : word.title;

    final hintText = isFrontVietnamese
        ? 'Chạm thẻ để xem từ tiếng Anh'
        : 'Chạm thẻ để xem giải nghĩa';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.brandSurface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd), // 12px
        border: Border.all(color: AppTheme.brandBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header Mặt Trước
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.chipIndigoBg,
                  borderRadius: BorderRadius.circular(AppTheme.radiusXs), // 4px
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppTheme.brandPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      badgeText,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.brandPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.volume_up_rounded, color: AppTheme.brandPrimary, size: 24),
                    onPressed: onSpeak,
                    tooltip: 'Phát âm',
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: Icon(
                      isStarred ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: isStarred ? AppTheme.brandAccent : AppTheme.brandTextMuted,
                      size: 24,
                    ),
                    onPressed: onToggleStar,
                    tooltip: 'Yêu thích',
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),

          // Vùng thân thẻ: Cuộn an toàn và tap để lật thẻ
          Expanded(
            child: GestureDetector(
              onTap: onFlip,
              behavior: HitTestBehavior.opaque,
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Từ vựng to, rõ nét
                      Text(
                        mainTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isFrontVietnamese ? 28 : 34,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.brandTextPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),

                      // Phiên âm IPA (chỉ hiện khi không phải mặt tiếng Việt và showIpa = true)
                      if (!isFrontVietnamese && showIpa && word.formattedTranscription.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          word.formattedTranscription,
                          textAlign: TextAlign.center,
                          style: AppTheme.ipaStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),

                      // Nút chạm xem giải nghĩa
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.chipIndigoBg,
                          borderRadius: BorderRadius.circular(AppTheme.radiusSm), // 8px
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.touch_app_outlined, size: 16, color: AppTheme.brandPrimary),
                            const SizedBox(width: 6),
                            Text(
                              hintText,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.brandPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Dưới cùng: Chỉ dẫn lật thẻ
          GestureDetector(
            onTap: onFlip,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sync_alt_rounded, size: 14, color: AppTheme.brandTextMuted),
                SizedBox(width: 6),
                Text(
                  'Chạm bất kỳ đâu trên thẻ để lật',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.brandTextMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- MẶT SAU (Back) ---
  Widget _buildCardBack(BuildContext context) {
    final backBadgeText = isFrontVietnamese
        ? 'Từ vựng tiếng Anh'
        : 'Giải nghĩa chi tiết';

    final backMainTitle = isFrontVietnamese
        ? word.title
        : (word.viword.isNotEmpty ? word.viword : word.title);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.brandSurface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd), // 12px
        border: Border.all(color: AppTheme.brandBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header Mặt Sau
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isFrontVietnamese ? AppTheme.chipIndigoBg : AppTheme.tintGreenBg,
                  borderRadius: BorderRadius.circular(AppTheme.radiusXs),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 14,
                      color: isFrontVietnamese ? AppTheme.brandPrimary : AppTheme.tintGreenText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      backBadgeText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isFrontVietnamese ? AppTheme.brandPrimary : AppTheme.tintGreenText,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.volume_up_rounded, color: AppTheme.brandPrimary, size: 24),
                    onPressed: onSpeak,
                    tooltip: 'Phát âm',
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: Icon(
                      isStarred ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: isStarred ? AppTheme.brandAccent : AppTheme.brandTextMuted,
                      size: 24,
                    ),
                    onPressed: onToggleStar,
                    tooltip: 'Yêu thích',
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Nội dung cuộn an toàn chống tràn layout
          Expanded(
            child: GestureDetector(
              onTap: onFlip,
              behavior: HitTestBehavior.opaque,
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Từ vựng mặt sau nổi bật
                      Text(
                        backMainTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isFrontVietnamese ? 30 : 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.brandTextPrimary,
                        ),
                      ),

                      // Nếu mặt trước là Tiếng Việt, mặt sau hiện IPA nếu showIpa
                      if (isFrontVietnamese && showIpa && word.formattedTranscription.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          word.formattedTranscription,
                          textAlign: TextAlign.center,
                          style: AppTheme.ipaStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ),
                      ],

                      if (word.description.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          word.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: AppTheme.brandTextSecondary,
                          ),
                        ),
                      ],

                      // Khung Ví dụ ngữ cảnh (chỉ hiện khi showExample = true)
                      if (showExample && word.example.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.brandBackground,
                            borderRadius: BorderRadius.circular(AppTheme.radiusSm), // 8px
                            border: Border.all(color: AppTheme.brandBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'VÍ DỤ:',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.brandTextMuted,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                word.example,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.brandTextPrimary,
                                  height: 1.4,
                                ),
                              ),
                              if (word.videscription.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  word.videscription,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.brandTextSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Dưới cùng: Chỉ dẫn quay lại
          GestureDetector(
            onTap: onFlip,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sync_alt_rounded, size: 14, color: AppTheme.brandTextMuted),
                SizedBox(width: 6),
                Text(
                  'Chạm để quay lại mặt trước',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.brandTextMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
