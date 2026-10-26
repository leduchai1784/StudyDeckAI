import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/theme.dart';
import '../../../models/edu_word.dart';

/// Giao diện chế độ Gõ từ (Typing Mode)
/// Đọc tiếng Việt, gõ lại tiếng Anh - Nhập trực tiếp vào các ô chữ cái (Interactive Letter Slots)
/// Tự động mở bàn phím ảo và hỗ trợ chạm trực tiếp vào bất kỳ ô nào để mở lại bàn phím
class FlashcardTypingView extends StatefulWidget {
  final EduWord word;
  final ValueChanged<bool> onAnswer;
  final VoidCallback onSpeak;

  const FlashcardTypingView({
    super.key,
    required this.word,
    required this.onAnswer,
    required this.onSpeak,
  });

  @override
  State<FlashcardTypingView> createState() => _FlashcardTypingViewState();
}

class _FlashcardTypingViewState extends State<FlashcardTypingView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _cursorController;
  bool? _isCorrect;
  bool _submitted = false;
  bool _keyboardWasOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _focusNode.addListener(_onFocusChange);
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 530),
    )..repeat(reverse: true);

    // Tự động focus và kích hoạt mở bàn phím ảo ngay khi màn hình sẵn sàng
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestOpenKeyboard();
    });
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Kiểm tra chiều cao bàn phím ảo an toàn:
    // Chỉ unfocus khi bàn phím THỰC SỰ ĐÃ MỞ (bottom > 0) và sau đó bị người dùng ẩn đi (bottom == 0).
    // Tránh unfocus giữa chừng lúc bàn phím đang trong animation mở (bottom = 0 ở frame đầu).
    final bottom = View.of(context).viewInsets.bottom;
    if (bottom > 0) {
      _keyboardWasOpen = true;
    } else if (bottom == 0 && _keyboardWasOpen) {
      _keyboardWasOpen = false;
      if (_focusNode.hasFocus) {
        _focusNode.unfocus();
      }
    }
  }

  @override
  void didUpdateWidget(covariant FlashcardTypingView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.word.id != widget.word.id) {
      _resetState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _requestOpenKeyboard();
      });
    }
  }

  void _resetState() {
    _textController.clear();
    _isCorrect = null;
    _submitted = false;
    _keyboardWasOpen = false;
  }

  void _requestOpenKeyboard() {
    if (!mounted || _submitted) return;
    _focusNode.requestFocus();
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.removeListener(_onFocusChange);
    _cursorController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTapSlot(int index) {
    if (_submitted) return;
    _keyboardWasOpen = false;
    final targetOffset = min(index, _textController.text.length);
    _textController.selection = TextSelection.fromPosition(
      TextPosition(offset: targetOffset),
    );
    _requestOpenKeyboard();
    setState(() {});
  }

  void _giveHint() {
    if (_submitted) return;
    final target = widget.word.title.trim();
    final currentLength = _textController.text.length;
    if (currentLength < target.length) {
      final newText = target.substring(0, currentLength + 1);
      setState(() {
        _textController.text = newText;
        _textController.selection = TextSelection.fromPosition(
          TextPosition(offset: newText.length),
        );
      });
      _requestOpenKeyboard();
    } else {
      setState(() {
        _textController.text = target;
        _textController.selection = TextSelection.fromPosition(
          TextPosition(offset: target.length),
        );
      });
    }
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

    _focusNode.unfocus();
    widget.onSpeak();
  }

  void _onContinue() {
    widget.onAnswer(_isCorrect ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final targetWord = widget.word.title.trim();
    final targetLen = targetWord.length;

    // Tính toán kích thước ô chữ phù hợp theo độ dài từ
    double slotWidth;
    double slotHeight;
    double fontSize;
    double spacing;

    if (targetLen <= 4) {
      slotWidth = 48;
      slotHeight = 56;
      fontSize = 24;
      spacing = 10;
    } else if (targetLen <= 7) {
      slotWidth = 40;
      slotHeight = 48;
      fontSize = 20;
      spacing = 8;
    } else if (targetLen <= 10) {
      slotWidth = 32;
      slotHeight = 40;
      fontSize = 17;
      spacing = 6;
    } else {
      slotWidth = 26;
      slotHeight = 34;
      fontSize = 14;
      spacing = 5;
    }

    // Xác định vị trí con trỏ hiện tại
    int activeCursorIndex = _textController.selection.baseOffset;
    if (activeCursorIndex < 0 || activeCursorIndex > _textController.text.length) {
      activeCursorIndex = _textController.text.length;
    }

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
          // Header: Tag chế độ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusXs),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.keyboard_rounded, size: 14, color: Color(0xFF0D9488)),
                    SizedBox(width: 4),
                    Text(
                      'Gõ từ tiếng Anh',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D9488),
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

          // Body: Cuộn được khi bàn phím xuất hiện, chống tràn tuyệt đối
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),

                    // Nghĩa tiếng Việt gợi ý
                    Text(
                      widget.word.viword.isNotEmpty ? widget.word.viword : widget.word.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brandTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Cụm ô chữ cái trực tiếp (Interactive Letter Slots)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _onTapSlot(_textController.text.length),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // TextField ẩn để bắt sự kiện gõ từ bàn phím hệ điều hành
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
                                onChanged: (val) => setState(() {}),
                                onSubmitted: (_) {
                                  if (!_submitted) {
                                    if (_textController.text.trim().isNotEmpty) {
                                      _checkAnswer();
                                    }
                                  } else {
                                    _onContinue();
                                  }
                                },
                              ),
                            ),
                          ),

                          // Các ô ký tự hiển thị trực tiếp - Mỗi ô đều hỗ trợ chạm để focus
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: spacing,
                            runSpacing: 8,
                            children: List.generate(targetLen, (index) {
                              final text = _textController.text;
                              final isFilled = index < text.length;
                              final char = isFilled ? text[index] : '';
                              final isCurrent = !_submitted && index == activeCursorIndex;

                              Color slotBg;
                              Border slotBorder;
                              Color textColor;
                              List<BoxShadow>? shadows;

                              if (_submitted) {
                                if (_isCorrect == true) {
                                  slotBg = AppTheme.tintGreenBg;
                                  slotBorder = Border.all(color: AppTheme.tintGreenText, width: 1.5);
                                  textColor = AppTheme.tintGreenText;
                                } else {
                                  slotBg = const Color(0xFFFFEBEA);
                                  slotBorder = Border.all(color: const Color(0xFFD32F2F), width: 1.5);
                                  textColor = const Color(0xFFD32F2F);
                                }
                              } else if (isCurrent) {
                                if (_focusNode.hasFocus) {
                                  // Đang được focus và bàn phím mở
                                  slotBg = const Color(0xFF0D9488).withValues(alpha: 0.08);
                                  slotBorder = Border.all(color: const Color(0xFF0D9488), width: 2.2);
                                  textColor = const Color(0xFF0D9488);
                                  shadows = [
                                    BoxShadow(
                                      color: const Color(0xFF0D9488).withValues(alpha: 0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ];
                                } else {
                                  // Chưa mở bàn phím nhưng đây là ô chờ nhập tiếp theo (gợi ý rõ ràng vị trí ô)
                                  slotBg = const Color(0xFF0D9488).withValues(alpha: 0.03);
                                  slotBorder = Border.all(
                                    color: const Color(0xFF0D9488).withValues(alpha: 0.6),
                                    width: 1.6,
                                  );
                                  textColor = const Color(0xFF0D9488);
                                }
                              } else if (isFilled) {
                                slotBg = AppTheme.brandSurface;
                                slotBorder = Border.all(color: const Color(0xFF0D9488), width: 1.5);
                                textColor = const Color(0xFF0D9488);
                              } else {
                                slotBg = AppTheme.brandBackground;
                                slotBorder = Border.all(color: AppTheme.brandBorder, width: 1.2);
                                textColor = AppTheme.brandTextPrimary;
                              }

                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => _onTapSlot(index),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  width: slotWidth,
                                  height: slotHeight,
                                  decoration: BoxDecoration(
                                    color: slotBg,
                                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                                    border: slotBorder,
                                    boxShadow: shadows,
                                  ),
                                  alignment: Alignment.center,
                                  child: char.isNotEmpty
                                      ? Text(
                                          char,
                                          style: TextStyle(
                                            fontSize: fontSize,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                        )
                                      : (isCurrent && _focusNode.hasFocus
                                          ? FadeTransition(
                                              opacity: _cursorController,
                                              child: Container(
                                                width: 2,
                                                height: fontSize * 0.8,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF0D9488),
                                                  borderRadius: BorderRadius.circular(1),
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink()),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),

                    // Thông báo kết quả Đúng / Sai mượt mà
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _submitted
                          ? Container(
                              key: const ValueKey('result_box'),
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 20),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: _isCorrect == true ? AppTheme.tintGreenBg : const Color(0xFFFFEBEA),
                                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _isCorrect == true ? Icons.check_circle_rounded : Icons.cancel_rounded,
                                    size: 20,
                                    color: _isCorrect == true ? AppTheme.tintGreenText : const Color(0xFFD32F2F),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      _isCorrect == true
                                          ? 'Chính xác! Xuất sắc 🎉'
                                          : 'Đáp án đúng: ${widget.word.title}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: _isCorrect == true
                                            ? AppTheme.tintGreenText
                                            : const Color(0xFFD32F2F),
                                      ),
                                    ),
                                  ),
                                ],
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

          // Nút Gợi ý & Kiểm tra ở đáy
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _submitted ? null : _giveHint,
                icon: const Icon(Icons.lightbulb_outline_rounded, size: 16, color: Color(0xFFF59E0B)),
                label: const Text(
                  'Gợi ý',
                  style: TextStyle(fontSize: 13, color: AppTheme.brandTextPrimary),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm), // 8px
                  ),
                  side: const BorderSide(color: AppTheme.brandBorder),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _submitted
                      ? _onContinue
                      : (_textController.text.trim().isEmpty ? null : _checkAnswer),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppTheme.brandBorder,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm), // 8px
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _submitted ? 'Tiếp tục' : 'Kiểm tra',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      if (_submitted) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
