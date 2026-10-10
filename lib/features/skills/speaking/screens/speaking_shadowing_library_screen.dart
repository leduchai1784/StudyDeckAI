import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../../shared/widgets/app_back_button.dart';
import '../data/speaking_shadowing_data.dart';
import '../models/speaking_shadowing_model.dart';
import 'speaking_shadowing_screen.dart';

class SpeakingShadowingLibraryScreen extends StatefulWidget {
  const SpeakingShadowingLibraryScreen({super.key});

  @override
  State<SpeakingShadowingLibraryScreen> createState() =>
      _SpeakingShadowingLibraryScreenState();
}

class _SpeakingShadowingLibraryScreenState
    extends State<SpeakingShadowingLibraryScreen> {
  int _selectedFilterIndex = 0;

  final List<Map<String, String>> _filters = [
    {'key': 'all', 'label': 'Tất cả chủ đề'},
    {'key': 'ielts_speaking', 'label': 'IELTS Band 8.0'},
    {'key': 'conversation', 'label': 'Hội thoại đời sống'},
  ];

  @override
  Widget build(BuildContext context) {
    const allExercises = SpeakingShadowingData.allExercises;
    List<ShadowingExercise> displayed = allExercises;

    final filterKey = _filters[_selectedFilterIndex]['key']!;
    if (filterKey != 'all') {
      displayed = allExercises.where((e) => e.category == filterKey).toList();
    }

    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const AppBackButton(),
        title: const Text(
          'Luyện Ngữ Điệu Shadowing',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppTheme.brandTextPrimary,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.tintIndigoBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppTheme.brandPrimary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.record_voice_over_rounded,
                    size: 14, color: AppTheme.brandPrimary),
                const SizedBox(width: 5),
                Text(
                  '${allExercises.length} Chủ đề',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
                    ),
                    child: const Icon(
                      Icons.record_voice_over_rounded,
                      color: Color(0xFFD97706),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kỹ Thuật Nhại Giọng (Shadowing)',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.brandTextPrimary,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Nghe người bản xứ nói, nhại lại qua Micro và nhận đánh giá so khớp phát âm từng từ tức thì.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_filters.length, (idx) {
                  final isSelected = _selectedFilterIndex == idx;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_filters[idx]['label']!),
                      selected: isSelected,
                      onSelected: (_) =>
                          setState(() => _selectedFilterIndex = idx),
                      selectedColor: AppTheme.brandPrimary,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color:
                            isSelected ? Colors.white : const Color(0xFF475569),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isSelected
                              ? AppTheme.brandPrimary
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      showCheckmark: false,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            // Section Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text('🎙️', style: TextStyle(fontSize: 15)),
                    SizedBox(width: 6),
                    Text(
                      'BÀI TẬP SHADOWING',
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
                  '${displayed.length} bài tập',
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Exercises List
            ...displayed.map((exercise) => _buildExerciseCard(exercise)),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(ShadowingExercise exercise) {
    final bool isIelts = exercise.category == 'ielts_speaking';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tags
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: isIelts
                      ? const Color(0xFFEEF2FF)
                      : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isIelts ? 'IELTS SPEAKING' : 'HỘI THOẠI',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isIelts
                        ? AppTheme.brandPrimary
                        : const Color(0xFF16A34A),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  exercise.bandTarget,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${exercise.sentences.length} câu luyện',
                style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Title
          Text(
            exercise.title,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.bold,
              color: AppTheme.brandTextPrimary,
            ),
          ),
          const SizedBox(height: 4),

          // Description
          Text(
            exercise.description,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          // Bottom Action
          Row(
            children: [
              const Icon(Icons.mic_none_rounded,
                  size: 14, color: Color(0xFF94A3B8)),
              const SizedBox(width: 4),
              const Text(
                'Ghi âm giọng nói thực tế',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SpeakingShadowingScreen(exercise: exercise),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow_rounded, size: 16),
                label: const Text('Bắt đầu'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.brandPrimary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
