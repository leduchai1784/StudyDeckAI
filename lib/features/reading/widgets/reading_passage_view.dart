import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../models/reading_test_model.dart';

class ReadingPassageView extends StatelessWidget {
  final ReadingPassage passage;
  final double fontSize;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  const ReadingPassageView({
    super.key,
    required this.passage,
    required this.fontSize,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Control Bar: Font Scaling & Passage Title
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.tintIndigoBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'PASSAGE ${passage.partNumber}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brandPrimary,
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  'Cỡ chữ: ',
                  style: TextStyle(fontSize: 12, color: AppTheme.brandTextSecondary),
                ),
                InkWell(
                  onTap: onZoomOut,
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: const Text('A-', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: onZoomIn,
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: const Text('A+', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Passage Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    passage.title,
                    style: TextStyle(
                      fontSize: fontSize + 4,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brandTextPrimary,
                      height: 1.3,
                    ),
                  ),
                  if (passage.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      passage.subtitle,
                      style: TextStyle(
                        fontSize: fontSize - 1,
                        fontStyle: FontStyle.italic,
                        color: AppTheme.brandTextSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  const Divider(color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 10),
                  SelectableText(
                    passage.content,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: const Color(0xFF1E293B),
                      height: 1.65,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
