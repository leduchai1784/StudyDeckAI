import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';

class DeckListScreen extends StatefulWidget {
  const DeckListScreen({super.key});

  @override
  State<DeckListScreen> createState() => _DeckListScreenState();
}

class _DeckListScreenState extends State<DeckListScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['Tất cả', 'Giao tiếp', 'Business', 'IELTS', 'CNTT'];

  final List<Map<String, dynamic>> _decks = [
    {
      'title': 'Tiếng Anh Giao Tiếp Công Sở',
      'count': 120,
      'mastered': 85,
      'dueForReview': 12,
      'category': 'Business',
      'color': const Color(0xFF4F46E5),
      'icon': Icons.business_center,
    },
    {
      'title': 'Từ Vựng IELTS Writing Task 2',
      'count': 250,
      'mastered': 140,
      'dueForReview': 6,
      'category': 'IELTS',
      'color': const Color(0xFF6C5CE7),
      'icon': Icons.edit_note,
    },
    {
      'title': 'Giao Tiếp Hàng Ngày Cho Nguồn Lực',
      'count': 80,
      'mastered': 70,
      'dueForReview': 0,
      'category': 'Giao tiếp',
      'color': const Color(0xFF00CEC9),
      'icon': Icons.record_voice_over,
    },
    {
      'title': 'Chuyên Ngành Lập Trình & IT',
      'count': 150,
      'mastered': 45,
      'dueForReview': 18,
      'category': 'CNTT',
      'color': const Color(0xFFE67E22),
      'icon': Icons.code,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Danh sách Bộ Thẻ Flashcards',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.onSurface),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppTheme.primaryContainer, size: 28),
            onPressed: () => context.push('/create-flashcard'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm bộ thẻ từ vựng...',
                  prefixIcon: const Icon(Icons.search, color: AppTheme.outline),
                  filled: true,
                  fillColor: AppTheme.surfaceContainerLowest,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppTheme.outlineVariant),
                  ),
                ),
              ),
            ),

            // Category Chips
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isSelected = _selectedCategoryIndex == index;
                  return ChoiceChip(
                    label: Text(_categories[index]),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryContainer,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.onSurface,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategoryIndex = index);
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // Grid / List of Decks
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20.0),
                itemCount: _decks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final deck = _decks[index];
                  final count = deck['count'] as int;
                  final mastered = deck['mastered'] as int;
                  final due = deck['dueForReview'] as int;
                  final progress = mastered / count;

                  return Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.4)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => context.push('/flashcard-review'),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: (deck['color'] as Color).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(deck['icon'] as IconData, color: deck['color'] as Color, size: 24),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          deck['title'] as String,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '$mastered / $count thẻ đã thuộc • ${deck['category']}',
                                          style: const TextStyle(fontSize: 13, color: AppTheme.onSurfaceVariant),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (due > 0)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFE0B2),
                                        borderRadius: BorderRadius.circular(99),
                                      ),
                                      child: Text(
                                        '$due cần ôn',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFE65100),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 6,
                                  backgroundColor: AppTheme.surfaceContainerLow,
                                  valueColor: AlwaysStoppedAnimation<Color>(deck['color'] as Color),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
