import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// Clean, borderless back button showing only the chevron icon,
/// synchronized across the StudyDeck AI application.
class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final double iconSize;

  const AppBackButton({
    super.key,
    this.onPressed,
    this.color,
    this.iconSize = 26,
    // Kept for backward compatibility
    Color? backgroundColor,
    Color? borderColor,
    double? size,
    double? borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.chevron_left_rounded,
        size: iconSize,
        color: color ?? AppTheme.brandTextPrimary,
      ),
      tooltip: 'Quay lại',
      splashRadius: 22,
      onPressed: onPressed ?? () => Navigator.maybePop(context),
    );
  }
}
