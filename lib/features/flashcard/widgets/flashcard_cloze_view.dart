import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../models/edu_word.dart';

/// Giao diện chế độ Điền vào chỗ trống (Cloze Test)
/// Ẩn từ vựng trong câu ví dụ, người học điền từ vựng đúng ngữ cảnh
/// Thiết kế an toàn chống tràn màn hình (Overflow-Proof)
class FlashcardClozeView extends StatefulWidget {
  final EduWord word;
  final ValueChanged<bool> onAnswer;
  final VoidCallback onSpeak;

  const FlashcardClozeView({
    super.key,
    required this.word,
    required this.onAnswer,
    required this.onSpeak,
  });

  @override
  State<FlashcardClozeView> createState() => _FlashcardClozeViewState();
}

class _FlashcardClozeViewState extends State<FlashcardClozeView> {
  final TextEditingController _textController = TextEditingController();
  bool? _isCorrect;
  bool _submitted = false;

  @override
  void didUpdateWidget(covariant FlashcardClozeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.word.id != widget.word.id) {
      _textController.clear();
      _isCorrect = null;
      _submitted = false;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    if (_submitted) return;
    final input = _textController.text.trim().toLowerCase();
    final target = widget.word.title.trim().toLowerCase();
    final correct = input == target;

    setState(() {
      _isCorrect = correct;
      _submitted = true;
    });

    widget.onSpeak();
    widget.onAnswer(correct);
  }

  String _getClozeSentence() {
    final example = widget.word.example.trim();
    final target = widget.word.title.trim();

    if (example.isEmpty) {
      return 'Please fill in the missing word: [ ______ ]';
    }

    // Thay thế từ vựng (không phân biệt hoa thường) bằng [ ______ ]
    final regex = RegExp(RegExp.escape(target), caseSensitive: false);
    if (regex.hasMatch(example)) {
      return example.replaceAll(regex, '[ ______ ]');
    }
    return '$example ([ ______ ])';
  }

  @override
  Widget build(BuildContext context) {
    final clozeSentence = _getClozeSentence();

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
        children: [
          // Header: Tag Điền chỗ trống
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusXs),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit_note_rounded, size: 14, color: Color(0xFF8B5CF6)),
                    SizedBox(width: 4),
                    Text(
                      'Điền vào chỗ trống',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B5CF6),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.volume_up_rounded, color: AppTheme.brandPrimary, size: 24),
                onPressed: widget.onSpeak,
                tooltip: 'Phát âm',
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),

          // Body: Cuộn an toàn chống tràn tuyệt đối
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),

                    // Gợi ý nghĩa từ
                    Text(
                      'Gợi ý: ${widget.word.viword}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brandTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Câu văn có chỗ trống
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.brandBackground,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                        border: Border.all(color: AppTheme.brandBorder),
                      ),
                      child: Text(
                        clozeSentence,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.brandTextPrimary,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Ô nhập từ cần điền
                    TextField(
                      controller: _textController,
                      textAlign: TextAlign.center,
                      autofocus: false,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brandTextPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Nhập từ thích hợp vào ô trống...',
                        hintStyle: const TextStyle(fontSize: 13, color: AppTheme.brandTextMuted),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        filled: true,
                        fillColor: AppTheme.brandBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                          borderSide: const BorderSide(color: AppTheme.brandBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                          borderSide: const BorderSide(color: AppTheme.brandBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                          borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 1.5),
                        ),
                      ),
                      onChanged: (val) => setState(() {}),
                      onSubmitted: (_) => _checkAnswer(),
                    ),

                    // Kết quả
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _submitted
                          ? Container(
                              key: const ValueKey('cloze_result'),
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: _isCorrect == true ? AppTheme.tintGreenBg : const Color(0xFFFFEBEA),
                                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                              ),
                              child: Text(
                                _isCorrect == true
                                    ? 'Chính xác! 🎉 Từ cần điền: ${widget.word.title}'
                                    : 'Đáp án đúng là: ${widget.word.title}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: _isCorrect == true ? AppTheme.tintGreenText : const Color(0xFFD32F2F),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Nút Kiểm tra
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _textController.text.trim().isEmpty ? null : _checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppTheme.brandBorder,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                elevation: 0,
              ),
              child: Text(
                _submitted ? 'Đã nộp bài' : 'Kiểm tra',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
