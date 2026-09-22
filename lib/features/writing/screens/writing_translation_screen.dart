import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../data/writing_mock_data.dart';
import '../models/writing_model.dart';

class WritingTranslationScreen extends StatefulWidget {
  const WritingTranslationScreen({super.key});

  @override
  State<WritingTranslationScreen> createState() => _WritingTranslationScreenState();
}

class _WritingTranslationScreenState extends State<WritingTranslationScreen> {
  int _selectedStep = 1; // 1: Cấu trúc câu, 2: Collocations & Vocab
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, bool> _revealed = {};

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _getController(String id) {
    if (!_controllers.containsKey(id)) {
      _controllers[id] = TextEditingController();
    }
    return _controllers[id]!;
  }

  @override
  Widget build(BuildContext context) {
    const allItems = WritingMockData.translationItems;
    final displayedItems = allItems.where((item) => item.step == _selectedStep).toList();

    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppTheme.brandTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tập Dịch IELTS',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
            color: AppTheme.brandTextPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Step Switcher
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStepTab(
                      label: 'Bước 1: Cấu trúc câu',
                      step: 1,
                    ),
                  ),
                  Expanded(
                    child: _buildStepTab(
                      label: 'Bước 2: Collocations',
                      step: 2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 2. Step description header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFC7D2FE)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppTheme.brandPrimary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedStep == 1
                          ? 'Luyện dịch câu đơn, câu phức từ Việt sang Anh. Tập trung dùng đúng thì và liên từ.'
                          : 'Dịch câu chứa các cụm từ (collocations) và từ vựng học thuật ghi điểm Band 7.5+.',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF3730A3), height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 3. Translation Cards
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayedItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, idx) {
                final item = displayedItems[idx];
                return _buildTranslationCard(item, idx + 1);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepTab({required String label, required int step}) {
    final isSelected = _selectedStep == step;
    return GestureDetector(
      onTap: () => setState(() => _selectedStep = step),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppTheme.brandPrimary : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildTranslationCard(WritingTranslationItem item, int index) {
    final controller = _getController(item.id);
    final isRevealed = _revealed[item.id] ?? false;

    return Container(
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Category tag
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Câu $index • ${item.category}',
                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Vietnamese sentence prompt
          Text(
            item.vietnameseSentence,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),

          // User translation input field
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: TextField(
              controller: controller,
              maxLines: 2,
              style: const TextStyle(fontSize: 13, height: 1.35),
              decoration: const InputDecoration(
                hintText: 'Nhập bản dịch tiếng Anh của bạn tại đây...',
                hintStyle: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Action button: Check answer
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _revealed[item.id] = !isRevealed;
                  });
                },
                icon: Icon(
                  isRevealed ? Icons.visibility_off_outlined : Icons.check_circle_outline_rounded,
                  size: 15,
                ),
                label: Text(
                  isRevealed ? 'Ẩn đáp án' : 'Xem đáp án mẫu & Phân tích',
                  style: const TextStyle(fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.brandPrimary,
                  side: const BorderSide(color: AppTheme.brandPrimary),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),

          // Answer Reveal box
          if (isRevealed) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF86EFAC)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '✅ Bản dịch mẫu Band 8.0+:',
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.englishSample,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF14532D), height: 1.35),
                  ),
                  if (item.keyCollocations.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Text(
                      '🔑 Collocations then chốt:',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: item.keyCollocations.map((c) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFF86EFAC)),
                          ),
                          child: Text(c, style: const TextStyle(fontSize: 11, color: Color(0xFF166534), fontWeight: FontWeight.w500)),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    '💡 ${item.explanation}',
                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF475569), height: 1.35),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
