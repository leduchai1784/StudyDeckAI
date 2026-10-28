import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/theme.dart';
import '../../../models/edu_word.dart';

/// Giao diện chế độ Điền vào chỗ trống (Cloze Test)
/// - Ẩn từ vựng trong câu ví dụ, người học điền từ vựng đúng ngữ cảnh.
/// - Khi kiểm tra:
///   + Đúng: Báo xanh, tự động phát âm, lật 3D sang mặt sau hiển thị chi tiết từ vựng và câu ví dụ hoàn chỉnh.
///   + Sai: Báo đỏ, lật 3D sang mặt sau hiển thị 'Đáp án: [Từ vựng]' để người học đối chiếu.
/// - Nhấn 'Tiếp tục' để chuyển sang từ tiếp theo.
/// - Thiết kế an toàn chống tràn màn hình (Overflow-Proof) khi mở bàn phím ảo.
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

class _FlashcardClozeViewState extends State<FlashcardClozeView>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  late AnimationController _cursorController;
  late FocusNode _focusNode;

  final TextEditingController _textController = TextEditingController();
  bool _showHint = false;
  bool? _isCorrect;
  bool _submitted = false;
  bool _isCardFlipped = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutCubic),
    );
    _focusNode = FocusNode();
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant FlashcardClozeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.word.id != widget.word.id) {
      _resetState();
    }
  }

  void _resetState() {
    _flipController.reset();
    _textController.clear();
    _showHint = false;
    _isCorrect = null;
    _submitted = false;
    _isCardFlipped = false;
    _focusNode.canRequestFocus = true;
    _cursorController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _flipController.dispose();
    _cursorController.dispose();
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onTapSlot() {
    if (_submitted) {
      _toggleFlip();
      return;
    }
    _textController.selection = TextSelection.fromPosition(
      TextPosition(offset: _textController.text.length),
    );
    _focusNode.requestFocus();
    SystemChannels.textInput.invokeMethod('TextInput.show');
    setState(() {});
  }

  void _checkAnswer() {
    if (_submitted) return;
    final input = _textController.text.trim().toLowerCase();
    final target = widget.word.title.trim().toLowerCase();
    final correct = input == target;

    _focusNode.canRequestFocus = false;
    _focusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _cursorController.stop();

    setState(() {
      _isCorrect = correct;
      _submitted = true;
      _isCardFlipped = true;
    });

    widget.onSpeak();
    _flipController.forward();
  }

  void _toggleFlip() {
    if (!_submitted) return;
    if (_flipController.isAnimating) return;
    _focusNode.canRequestFocus = false;
    _focusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (_isCardFlipped) {
      _flipController.reverse();
      setState(() {
        _isCardFlipped = false;
      });
    } else {
      _flipController.forward();
      setState(() {
        _isCardFlipped = true;
      });
    }
  }

  void _onContinue() {
    widget.onAnswer(_isCorrect ?? false);
  }

  String _getClozeSentence() {
    final example = widget.word.example.trim();
    final target = widget.word.title.trim();

    // Số lượng dấu gạch dưới đúng bằng số ký tự của từ nhập vào
    final count = target.isEmpty ? 4 : target.length;
    final blankPlaceholder = '[ ${List.filled(count, '_').join(' ')} ]';

    if (example.isEmpty) {
      return 'Please fill in the missing word: $blankPlaceholder';
    }

    // Thay thế từ vựng (không phân biệt hoa thường) bằng [ _ _ ... _ ] với số ký tự khớp 100%
    final regex = RegExp(RegExp.escape(target), caseSensitive: false);
    if (regex.hasMatch(example)) {
      return example.replaceAll(regex, blankPlaceholder);
    }
    return '$example ($blankPlaceholder)';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Thẻ Flashcard trung tâm với hiệu ứng lật 3D (chạm vào thẻ để lật qua lại sau khi đã nộp)
        Expanded(
          child: GestureDetector(
            key: const ValueKey('flashcard_cloze_card'),
            behavior: HitTestBehavior.opaque,
            onTap: _submitted ? _toggleFlip : null,
            child: AnimatedBuilder(
              animation: _flipAnimation,
              builder: (context, child) {
                final angle = _flipAnimation.value * pi;
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
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Nút hành động dưới đáy thẻ
        _buildBottomActions(),
      ],
    );
  }

  // --- MẶT TRƯỚC (Front: Tag Điền chỗ trống, câu ví dụ có [ _ _ _ ] & Dấu gạch chân nhập từ) ---
  Widget _buildCardFront(BuildContext context) {
    final clozeSentence = _getClozeSentence();
    final targetWord = widget.word.title.trim();
    final targetLen = targetWord.length;

    double slotWidth;
    double slotHeight;
    double fontSize;
    double spacing;

    if (targetLen <= 4) {
      slotWidth = 44;
      slotHeight = 52;
      fontSize = 24;
      spacing = 10;
    } else if (targetLen <= 7) {
      slotWidth = 36;
      slotHeight = 44;
      fontSize = 20;
      spacing = 8;
    } else if (targetLen <= 10) {
      slotWidth = 28;
      slotHeight = 36;
      fontSize = 17;
      spacing = 6;
    } else {
      slotWidth = 22;
      slotHeight = 30;
      fontSize = 14;
      spacing = 4;
    }

    final activeCursorIndex = _textController.text.length;

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
          // Header: Tag Điền chỗ trống + Nút Loa
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

          const SizedBox(height: 8),

          // Body: Căn giữa theo chiều dọc, cuộn an toàn chống tràn khi bàn phím mở
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Gợi ý nghĩa tiếng Việt
                    Text(
                      _showHint
                          ? 'Gợi ý: ${widget.word.viword.isNotEmpty ? widget.word.viword : widget.word.description}'
                          : 'Gợi ý: [Chạm "Gợi ý" để xem nghĩa]',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: _showHint ? FontWeight.bold : FontWeight.w500,
                        color: _showHint ? AppTheme.brandPrimary : AppTheme.brandTextMuted,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Khối câu ví dụ có chỗ trống [ ______ ]
                    Container(
                      width: double.infinity,
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

                    const SizedBox(height: 22),

                    // Cụm các dấu gạch chân tương ứng với số lượng ký tự trong từ
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _onTapSlot,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // TextField ẩn để bắt sự kiện gõ từ bàn phím hệ điều hành
                          if (!_submitted)
                            Positioned(
                              width: 1,
                              height: 1,
                              child: Opacity(
                                opacity: 0.0,
                                child: TextField(
                                  controller: _textController,
                                  focusNode: _focusNode,
                                  autofocus: true,
                                  keyboardType: TextInputType.text,
                                  maxLength: targetLen,
                                  textInputAction: TextInputAction.done,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.none,
                                  decoration: const InputDecoration(
                                    counterText: '',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onChanged: (val) {
                                    if (_textController.selection.baseOffset != _textController.text.length) {
                                      _textController.selection = TextSelection.fromPosition(
                                        TextPosition(offset: _textController.text.length),
                                      );
                                    }
                                    setState(() {});
                                  },
                                  onSubmitted: (_) {
                                    if (_textController.text.trim().isNotEmpty) {
                                      _checkAnswer();
                                    }
                                  },
                                ),
                              ),
                            ),

                          // Dãy dấu gạch chân đại diện cho từng ký tự
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: spacing,
                            runSpacing: 8,
                            children: List.generate(targetLen, (index) {
                              final text = _textController.text;
                              final isFilled = index < text.length;
                              final char = isFilled ? text[index] : '';
                              final isCurrent = !_submitted && index == activeCursorIndex;
                              final targetChar = index < targetWord.length ? targetWord[index] : '';
                              final isMatch = isFilled && char.toLowerCase() == targetChar.toLowerCase();

                              Color underlineColor;
                              double underlineWidth = 2.5;
                              Color textColor;

                              if (_submitted) {
                                if (isMatch) {
                                  underlineColor = AppTheme.tintGreenText;
                                  textColor = AppTheme.tintGreenText;
                                } else {
                                  underlineColor = const Color(0xFFD32F2F);
                                  textColor = const Color(0xFFD32F2F);
                                }
                              } else if (isCurrent) {
                                underlineColor = const Color(0xFF8B5CF6);
                                underlineWidth = 3.0;
                                textColor = const Color(0xFF8B5CF6);
                              } else if (isFilled) {
                                underlineColor = const Color(0xFF8B5CF6);
                                textColor = AppTheme.brandTextPrimary;
                              } else {
                                underlineColor = AppTheme.brandBorder;
                                textColor = AppTheme.brandTextPrimary;
                              }

                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                width: slotWidth,
                                height: slotHeight,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: underlineColor,
                                      width: underlineWidth,
                                    ),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    if (char.isNotEmpty)
                                      Text(
                                        char,
                                        style: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                    if (char.isEmpty && isCurrent && _focusNode.hasFocus)
                                      FadeTransition(
                                        opacity: _cursorController,
                                        child: Container(
                                          width: 2,
                                          height: fontSize * 0.85,
                                          color: const Color(0xFF8B5CF6),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Thông báo Đúng / Sai ở mép đáy mặt trước (đối xứng hoàn toàn với mặt sau khi đã nộp)
          if (_submitted) ...[
            const SizedBox(height: 12),
            Center(child: _buildResultBanner()),
          ],
        ],
      ),
    );
  }

  // --- MẶT SAU (Back: Chi tiết kiến thức đồng bộ với toàn bộ chế độ học) ---
  Widget _buildCardBack(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Tag "TIẾNG ANH" (trái) + Loa (phải)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TIẾNG ANH',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppTheme.brandTextMuted,
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

          const SizedBox(height: 8),

          // Body: Căn giữa theo chiều dọc cho cân đối và đỡ trống thẻ
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Từ vựng tiếng Anh to đậm
                      Text(
                        widget.word.title,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.brandTextPrimary,
                          letterSpacing: -0.5,
                          height: 1.15,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Phiên âm IPA & Nghĩa tiếng Việt
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (widget.word.formattedTranscription.isNotEmpty) ...[
                            Text(
                              widget.word.formattedTranscription,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.brandTextSecondary,
                              ),
                            ),
                            const Text(
                              ' · ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.brandTextMuted,
                              ),
                            ),
                          ],
                          Text(
                            widget.word.viword.isNotEmpty
                                ? widget.word.viword
                                : widget.word.description,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.brandTextPrimary,
                            ),
                          ),
                        ],
                      ),

                      // Khối câu ví dụ (Example box với viền vàng hổ phách)
                      if (widget.word.example.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color(0xFFF59E0B), // Vàng Amber
                                width: 3.5,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '"${widget.word.example}"',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.brandTextPrimary,
                                  height: 1.4,
                                ),
                              ),
                              if (widget.word.videscription.isNotEmpty ||
                                  widget.word.description.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  widget.word.videscription.isNotEmpty
                                      ? widget.word.videscription
                                      : widget.word.description,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    color: AppTheme.brandTextSecondary,
                                    height: 1.3,
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

          // Thông báo Đúng / Sai ở dưới đáy mặt sau (đối xứng hoàn toàn với mặt trước)
          if (_submitted) ...[
            const SizedBox(height: 12),
            Center(child: _buildResultBanner()),
          ],
        ],
      ),
    );
  }

  // --- BANNER THÔNG BÁO ĐÚNG / SAI ---
  Widget _buildResultBanner() {
    final isCorrect = _isCorrect == true;
    return Container(
      key: const ValueKey('result_box'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isCorrect ? AppTheme.tintGreenBg : const Color(0xFFFFEBEA),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 18,
            color: isCorrect ? AppTheme.tintGreenText : const Color(0xFFD32F2F),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              isCorrect ? 'Chính xác!' : 'Đáp án: ${widget.word.title}',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
                color: isCorrect ? AppTheme.tintGreenText : const Color(0xFFD32F2F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- NÚT HÀNH ĐỘNG DƯỚI ĐÁY ---
  Widget _buildBottomActions() {
    if (_submitted) {
      // Khi đã nộp bài: Nút Tiếp tục (Teal)
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: _onContinue,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D9488),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusSm), // 8px
            ),
            elevation: 0,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tiếp tục',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 6),
              Icon(Icons.arrow_forward_rounded, size: 18),
            ],
          ),
        ),
      );
    }

    // Khi chưa nộp: Hàng nút Gợi ý & Kiểm tra
    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: () {
            setState(() {
              _showHint = !_showHint;
            });
          },
          icon: Icon(
            _showHint ? Icons.lightbulb_rounded : Icons.lightbulb_outline_rounded,
            size: 16,
            color: const Color(0xFFF59E0B),
          ),
          label: const Text(
            'Gợi ý',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.brandTextPrimary,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            side: const BorderSide(color: AppTheme.brandBorder),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _textController.text.trim().isEmpty ? null : _checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppTheme.brandBorder,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Kiểm tra',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
