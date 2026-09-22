import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import 'studydeck_logo_header.dart';

class SurveyProgressHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBack;

  const SurveyProgressHeader({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final double percent = (currentStep / totalSteps * 100).roundToDouble();

    return Column(
      children: [
        // Top Row: Back button + Centered StudyDeck AI Badge
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppTheme.brandTextPrimary),
              onPressed: onBack ??
                  () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/onboarding');
                    }
                  },
            ),
            const Expanded(
              child: Center(
                child: StudyDeckHeaderBadge(),
              ),
            ),
            const SizedBox(width: 48), // Balance spacing for back icon
          ],
        ),
        const SizedBox(height: 8),

        // Step Label & Percentage Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.chipIndigoBg,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '• Bước $currentStep/$totalSteps',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brandPrimary,
                ),
              ),
            ),
            Text(
              '${percent.toInt()}% hoàn thành',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.brandPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // 4 Segmented Progress Pills Row
        Row(
          children: List.generate(totalSteps, (index) {
            final isFilled = index < currentStep;
            return Expanded(
              child: Container(
                height: 6,
                margin: EdgeInsets.only(right: index < totalSteps - 1 ? 6 : 0),
                decoration: BoxDecoration(
                  color: isFilled ? AppTheme.brandPrimary : AppTheme.chipIndigoBg,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
