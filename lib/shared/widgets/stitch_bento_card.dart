import 'package:flutter/material.dart';
import '../../app/theme.dart';

class StitchBentoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color iconBackgroundColor;
  final Color iconColor;
  final bool showArrow;
  final VoidCallback? onTap;

  const StitchBentoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.iconBackgroundColor,
    required this.iconColor,
    this.showArrow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final childContent = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandTextPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.brandTextSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          if (showArrow)
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppTheme.brandTextMuted,
            ),
        ],
      ),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.brandSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.brandBorder),
      ),
      child: onTap != null
          ? Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onTap,
                child: childContent,
              ),
            )
          : childContent,
    );
  }
}
