import 'package:flutter/material.dart';
import '../../app/theme.dart';

class StudyDeckHeaderBadge extends StatelessWidget {
  final double iconSize;

  const StudyDeckHeaderBadge({
    super.key,
    this.iconSize = 26.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/icons/app_logo.png',
          height: iconSize,
          width: iconSize,
          errorBuilder: (context, error, stackTrace) => Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: AppTheme.brandPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.style, color: Colors.white, size: 16),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'StudyDeck',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.brandTextPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.brandAccent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'AI',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class StudyDeckLogoHeader extends StatelessWidget {
  final double? height;
  final double? width;
  final bool showSubtitle;

  const StudyDeckLogoHeader({
    super.key,
    this.height,
    this.width,
    this.showSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/app_logo_full.png',
      height: height,
      width: width,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const StudyDeckHeaderBadge();
      },
    );
  }
}
