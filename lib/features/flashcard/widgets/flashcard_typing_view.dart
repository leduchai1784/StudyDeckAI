import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/theme.dart';
import '../../../models/edu_word.dart';

/// Giao diện chế độ Gõ từ (Typing Mode)
/// Đọc tiếng Việt, gõ lại tiếng Anh - Nhập trực tiếp vào các ô chữ cái (Interactive Letter Slots)
/// Tự động lật mặt thẻ 3D khi bấm Kiểm tra (Đúng/Sai) theo chuẩn IELTS Dictionary
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
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _cursorController;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  bool? _isCorrect;
  bool _submitted = false;
  bool _isCardFlipped = false;
  bool _keyboardWasOpen = false;
  bool _showHint = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _focusNode.addListener(_onFocusChange);

    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 530),
    )..repeat(reverse: true);

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutCubic),
    );

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
    // Chỉ unfocus khi bàn phím THỰC SỰ ĐÃ MỞ (bottom > 0) và sau đó bị người dùng ẩn đi (bottom == 0).
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
    _isCardFlipped = false;
    _keyboardWasOpen = false;
    _showHint = false;
    _focusNode.canRequestFocus = true;
    _cursorController.repeat(reverse: true);
    _flipController.reset();
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
    _flipController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTapSlot([int? index]) {
    if (_submitted) {
      _toggleFlip();
      return;
    }
    _keyboardWasOpen = false;
    // Luôn khóa vị trí con trỏ ở cuối chuỗi đã gõ để đảm bảo nhập và xóa đúng thứ tự tuần tự
    _textController.selection = TextSelection.fromPosition(
      TextPosition(offset: _textController.text.length),
    );
    _requestOpenKeyboard();
    setState(() {});
  }

  void _giveHint() {
    if (_submitted) return;
    setState(() {
      _showHint = true;
    });
    _requestOpenKeyboard();
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

    // Vị trí con trỏ nhập ký tự luôn ở cuối chuỗi đã gõ để nhập/xóa tuần tự theo thứ tự
    final activeCursorIndex = _textController.text.length;

    return Column(
      children: [
        // Thẻ Flashcard trung tâm với hiệu ứng lật 3D (chạm vào thẻ để lật)
        Expanded(
          child: GestureDetector(
            key: const ValueKey('flashcard_typing_card'),
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
                      : _buildCardFront(
                          context,
                          slotWidth,
                          slotHeight,
                          fontSize,
                          spacing,
                          activeCursorIndex,
                          targetLen,
                        ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Nút Gợi ý & Kiểm tra / Tiếp tục ở đáy
        _buildBottomActions(),
      ],
    );
  }

  // --- MẶT TRƯỚC (Front: Gõ từ vựng vào ô ký tự) ---
  Widget _buildCardFront(
    BuildContext context,
    double slotWidth,
    double slotHeight,
    double fontSize,
    double spacing,
    int activeCursorIndex,
    int targetLen,
  ) {
    final targetWord = widget.word.title.trim();
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

          const SizedBox(height: 8),

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
                          // TextField ẩn để bắt sự kiện gõ từ bàn phím hệ điều hành (chỉ mount khi chưa kiểm tra)
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
                              final targetChar = index < targetWord.length ? targetWord[index] : '';
                              final isMatch = isFilled && char.toLowerCase() == targetChar.toLowerCase();

                              Color slotBg;
                              Border slotBorder;
                              Color textColor;
                              List<BoxShadow>? shadows;

                              if (_submitted) {
                                if (isMatch) {
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

                              // Ký tự gợi ý mờ (chữ đầu và chữ cuối của từ) khi nhấn Gợi ý
                              String hintChar = '';
                              if (!isFilled && _showHint) {
                                if (index == 0 && targetLen > 0) {
                                  hintChar = targetWord[0];
                                } else if (index == targetLen - 1 && targetLen > 1) {
                                  hintChar = targetWord[targetLen - 1];
                                }
                              }

                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: _onTapSlot,
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
                                        )
                                      else if (hintChar.isNotEmpty)
                                        Text(
                                          hintChar,
                                          style: TextStyle(
                                            fontSize: fontSize,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.brandTextMuted.withValues(alpha: 0.38),
                                          ),
                                        ),
                                      if (char.isEmpty && isCurrent && _focusNode.hasFocus)
                                        FadeTransition(
                                          opacity: _cursorController,
                                          child: Container(
                                            width: 2,
                                            height: fontSize * 0.8,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF0D9488),
                                              borderRadius: BorderRadius.circular(1),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
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

          // Thông báo Đúng / Sai ở dưới đáy mặt trước (đối xứng hoàn toàn với mặt sau)
          if (_submitted) ...[
            const SizedBox(height: 12),
            Center(child: _buildResultBanner()),
          ],
        ],
      ),
    );
  }

  // --- MẶT SAU (Back: Chi tiết kiến thức theo ảnh mẫu IELTS Dictionary) ---
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
          // Header: Tag "TIẾNG ANH" (trái) + Nút "Sửa" và Loa (phải)
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

          // Body: Căn giữa theo chiều dọc cho cân đối và đỡ trống thẻ, cuộn được khi nội dung dài
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
                        widget.word.viword.isNotEmpty ? widget.word.viword : widget.word.description,
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
                          if (widget.word.videscription.isNotEmpty || widget.word.description.isNotEmpty) ...[
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

    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: _showHint ? null : _giveHint,
          icon: Icon(
            _showHint ? Icons.lightbulb_rounded : Icons.lightbulb_outline_rounded,
            size: 16,
            color: const Color(0xFFF59E0B),
          ),
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
            onPressed: _textController.text.trim().isEmpty ? null : _checkAnswer,
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
            child: const Text(
              'Kiểm tra',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
