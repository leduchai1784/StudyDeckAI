import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';
import '../../../services/tts_service.dart';
import '../models/chat_message_model.dart';
import '../services/gemini_ai_tutor_service.dart';

class AiTutorChatScreen extends StatefulWidget {
  final String? initialPrompt;
  final String? initialMode;

  const AiTutorChatScreen({
    super.key,
    this.initialPrompt,
    this.initialMode,
  });

  @override
  State<AiTutorChatScreen> createState() => _AiTutorChatScreenState();
}

class _AiTutorChatScreenState extends State<AiTutorChatScreen> {
  final GeminiAiTutorService _aiService = GeminiAiTutorService();
  final TtsService _ttsService = TtsService();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  bool _isLoading = false;
  String? _currentlySpeakingId;
  String _selectedMode = 'all';

  // Danh sách câu hỏi gợi ý chuẩn theo 4 kỹ năng IELTS (Listening, Speaking, Reading, Writing)
  static const List<Map<String, String>> _allSkillPrompts = [
    // 🎧 LISTENING
    {
      'skill': 'listening',
      'skillLabel': 'Listening',
      'icon': '🎧',
      'badge': 'Distractor',
      'label': '🎧 Mẹo bẫy Distractors trong Listening',
      'prompt': 'Chỉ giúp tôi các bẫy distractors phổ biến nhất trong IELTS Listening Part 1 & Part 2 kèm ví dụ và mẹo nhận diện để không bị lừa.',
    },
    {
      'skill': 'listening',
      'skillLabel': 'Listening',
      'icon': '🎧',
      'badge': 'Phương pháp',
      'label': '🎧 Kỹ thuật Nghe Chép Chính Tả (Dictation)',
      'prompt': 'Hướng dẫn tôi phương pháp luyện Nghe - Chép chính tả (Dictation) từng bước để tăng band điểm Listening từ 5.5 lên 7.0+.',
    },
    {
      'skill': 'listening',
      'skillLabel': 'Listening',
      'icon': '🎧',
      'badge': 'Part 4 Strategy',
      'label': '🎧 Bắt kịp từ nối Signposting Language',
      'prompt': 'Chia sẻ danh sách các từ nối chỉ hướng (Signposting Language) trong IELTS Listening Part 4 giúp người thi không bị lạc khi người nói giảng bài nhanh.',
    },

    // 🗣️ SPEAKING
    {
      'skill': 'speaking',
      'skillLabel': 'Speaking',
      'icon': '🗣️',
      'badge': 'Part 1 Mock',
      'label': '🗣️ Luyện Speaking Part 1: Hometown',
      'prompt': 'Hãy đóng vai giám khảo IELTS và hỏi tôi 1 câu hỏi Speaking Part 1 về chủ đề "Hometown". Hãy đợi tôi trả lời và nhận xét nâng band giúp tôi nhé!',
    },
    {
      'skill': 'speaking',
      'skillLabel': 'Speaking',
      'icon': '🗣️',
      'badge': 'Công thức',
      'label': '🗣️ Công thức A.R.E.A kéo dài câu trả lời',
      'prompt': 'Hướng dẫn tôi cách áp dụng công thức A.R.E.A (Action - Reason - Example - Alternative) để trả lời Speaking tự nhiên, mạch lạc mà không bị ngập ngừng.',
    },
    {
      'skill': 'speaking',
      'skillLabel': 'Speaking',
      'icon': '🗣️',
      'badge': 'Part 2 Cue Card',
      'label': '🗣️ Dàn ý Speaking Part 2: Describe a Person',
      'prompt': 'Gợi ý dàn ý 1 phút chuẩn bị và cụm từ Band 7.5+ cho đề Speaking Part 2: "Describe a person who inspired you to study hard".',
    },

    // 📖 READING
    {
      'skill': 'reading',
      'skillLabel': 'Reading',
      'icon': '📖',
      'badge': 'T/F/NG',
      'label': '📖 Phân biệt True / False / Not Given',
      'prompt': 'Giải thích chi tiết sự khác biệt giữa False và Not Given trong IELTS Reading, kèm ví dụ cụ thể và bẫy người ra đề hay gài nhất.',
    },
    {
      'skill': 'reading',
      'skillLabel': 'Reading',
      'icon': '📖',
      'badge': 'Chiến thuật',
      'label': '📖 Kỹ năng Skimming & Scanning 20 phút',
      'prompt': 'Hướng dẫn cách thực hành kỹ thuật Skimming (đọc lướt ý chính) và Scanning (quét từ khóa) để giải quyết bài đọc Reading trong 20 phút.',
    },
    {
      'skill': 'reading',
      'skillLabel': 'Reading',
      'icon': '📖',
      'badge': 'Headings',
      'label': '📖 Mẹo làm dạng Matching Headings',
      'prompt': 'Chia sẻ chiến thuật làm dạng bài Nối Tiêu Đề (Matching Headings) nhanh và chính xác nhất, cách nhận diện câu chủ đề đoạn văn.',
    },

    // ✍️ WRITING
    {
      'skill': 'writing',
      'skillLabel': 'Writing',
      'icon': '✍️',
      'badge': 'Nâng Band 7.5+',
      'label': '✍️ Sửa và nâng cấp câu Writing Task 2',
      'prompt': 'Sửa lỗi và nâng cấp câu sau lên Band 7.5+ giúp tôi: "Nowadays more and more people use cars, which makes the air in big cities very polluted and people get sick."',
    },
    {
      'skill': 'writing',
      'skillLabel': 'Writing',
      'icon': '✍️',
      'badge': 'Task 1 Graph',
      'label': '✍️ Cấu trúc miêu tả xu hướng Task 1 (Line Graph)',
      'prompt': 'Cho tôi 5 cấu trúc câu đa dạng miêu tả xu hướng tăng mạnh, giảm dần và dao động cho bài IELTS Writing Task 1 Line Graph chuẩn Band 8.0.',
    },
    {
      'skill': 'writing',
      'skillLabel': 'Writing',
      'icon': '✍️',
      'badge': 'Task 2 Ideas',
      'label': '✍️ Dàn bài Task 2: Artificial Intelligence',
      'prompt': 'Lập dàn bài luận Task 2 về đề tài: "Will AI replace teachers in classrooms?". Cung cấp luận điểm cho cả 2 phía và từ vựng học thuật ghi điểm cao.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedMode = widget.initialMode ?? 'all';
    _ttsService.init();
    _ttsService.isSpeakingNotifier.addListener(_onTtsStateChanged);
    _initChat();
  }

  Future<void> _initChat() async {
    await _aiService.loadHistory();
    if (mounted) {
      setState(() {});
      _scrollToBottom();

      // Nếu có initialPrompt được truyền vào từ màn trước
      if (widget.initialPrompt != null && widget.initialPrompt!.trim().isNotEmpty) {
        final prompt = widget.initialPrompt!.trim();
        _sendMessage(prompt, mode: widget.initialMode ?? _selectedMode);
      }
    }
  }

  @override
  void dispose() {
    _ttsService.isSpeakingNotifier.removeListener(_onTtsStateChanged);
    _ttsService.stop();
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTtsStateChanged() {
    if (!_ttsService.isSpeaking && _currentlySpeakingId != null && mounted) {
      setState(() {
        _currentlySpeakingId = null;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text, {String? mode}) async {
    if (text.trim().isEmpty || _isLoading) return;

    final messageText = text.trim();
    _textController.clear();

    setState(() {
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      await _aiService.sendMessage(
        userText: messageText,
        modeTag: mode ?? _selectedMode,
      );
    } catch (_) {
      // Error handled inside service
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _scrollToBottom();
      }
    }
  }

  void _stopGeneration() {
    _aiService.cancelCurrentRequest();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  Future<void> _toggleTts(String messageId, String text) async {
    if (_currentlySpeakingId == messageId) {
      // Đang phát âm câu này -> Dừng phát âm ngay lập tức
      await _ttsService.stop();
      if (mounted) {
        setState(() {
          _currentlySpeakingId = null;
        });
      }
    } else {
      // Dừng câu trước nếu đang phát
      await _ttsService.stop();
      if (!mounted) return;

      setState(() {
        _currentlySpeakingId = messageId;
      });

      // Loại bỏ các ký tự markdown và dấu gạch để giọng đọc tự nhiên
      final cleanedText = text
          .replaceAll(RegExp(r'\*\*|\*|#+|`'), '')
          .replaceAll(RegExp(r'\[.*?\]\(.*?\)'), '')
          .replaceAll(RegExp(r'^[-*_]{3,}$', multiLine: true), '')
          .trim();

      await _ttsService.speak(cleanedText);
    }
  }

  void _confirmClearHistory() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            const Icon(Icons.delete_outline_rounded, color: AppTheme.brandPrimary, size: 22),
            const SizedBox(width: 8),
            Text(
              'Làm Mới Đoạn Chat?',
              style: GoogleFonts.beVietnamPro(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Toàn bộ lịch sử trò chuyện với AI Tutor sẽ được xoá để bắt đầu phiên học mới.',
          style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppTheme.brandTextSecondary, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Huỷ', style: GoogleFonts.beVietnamPro(color: AppTheme.brandTextSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _ttsService.stop();
              await _aiService.clearHistory();
              if (mounted) {
                setState(() {
                  _currentlySpeakingId = null;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.brandPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Xoá Lịch Sử', style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = _aiService.messages;

    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1, thickness: 1, color: AppTheme.brandBorder),
        ),
        automaticallyImplyLeading: false,
        leading: context.canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.brandTextPrimary, size: 18),
                onPressed: () {
                  _ttsService.stop();
                  context.pop();
                },
              )
            : null,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppTheme.chipIndigoBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.brandPrimary.withValues(alpha: 0.15)),
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: AppTheme.brandPrimary, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'StudyDeck AI Tutor',
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.5,
                      color: AppTheme.brandTextPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Trợ lý 4 kỹ năng IELTS • Sẵn sàng 24/7',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 11,
                          color: AppTheme.brandTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Làm mới cuộc trò chuyện',
            icon: const Icon(Icons.refresh_rounded, color: AppTheme.brandTextSecondary, size: 22),
            onPressed: messages.isEmpty ? null : _confirmClearHistory,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat Messages Area
            Expanded(
              child: messages.isEmpty && !_isLoading
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      itemCount: messages.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == messages.length && _isLoading) {
                          return _buildLoadingBubble();
                        }
                        final message = messages[index];
                        return _buildMessageBubble(message);
                      },
                    ),
            ),

            // Bottom Input Bar
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // Banner Chào Mừng Phong Cách Bento
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.brandBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
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
                    color: AppTheme.chipIndigoBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppTheme.brandPrimary,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chào mừng bạn đến với AI Tutor!',
                        style: GoogleFonts.beVietnamPro(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppTheme.brandTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Hỗ trợ toàn diện 4 kỹ năng Nghe - Nói - Đọc - Viết. Bạn có thể hỏi bằng Tiếng Việt hoặc Tiếng Anh.',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          color: AppTheme.brandTextSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Tiêu Đề Gợi Ý 4 Kỹ Năng
          Row(
            children: [
              const Icon(Icons.explore_rounded, color: AppTheme.brandPrimary, size: 18),
              const SizedBox(width: 6),
              Text(
                'Gợi ý câu hỏi theo 4 Kỹ Năng IELTS:',
                style: GoogleFonts.beVietnamPro(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppTheme.brandTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 4 Khối Kỹ Năng (Bento Grid)
          _buildSkillCategoryCard(
            title: '🎧 Kỹ Năng Nghe (Listening)',
            badgeBg: AppTheme.tintIndigoBg,
            badgeTextColor: AppTheme.tintIndigoText,
            skill: 'listening',
          ),
          const SizedBox(height: 10),

          _buildSkillCategoryCard(
            title: '🗣️ Kỹ Năng Nói (Speaking)',
            badgeBg: AppTheme.tintPurpleBg,
            badgeTextColor: AppTheme.tintPurpleText,
            skill: 'speaking',
          ),
          const SizedBox(height: 10),

          _buildSkillCategoryCard(
            title: '📖 Kỹ Năng Đọc (Reading)',
            badgeBg: AppTheme.tintGreenBg,
            badgeTextColor: AppTheme.tintGreenText,
            skill: 'reading',
          ),
          const SizedBox(height: 10),

          _buildSkillCategoryCard(
            title: '✍️ Kỹ Năng Viết (Writing)',
            badgeBg: AppTheme.tintAmberBg,
            badgeTextColor: AppTheme.tintAmberText,
            skill: 'writing',
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSkillCategoryCard({
    required String title,
    required Color badgeBg,
    required Color badgeTextColor,
    required String skill,
  }) {
    final skillPrompts = _allSkillPrompts.where((p) => p['skill'] == skill).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.brandBorder),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  title,
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: badgeTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...skillPrompts.map((item) {
            return InkWell(
              onTap: () => _sendMessage(item['prompt']!, mode: skill),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_right_rounded, color: AppTheme.brandPrimary, size: 20),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item['label']!,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12.5,
                          color: AppTheme.brandTextPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Icon(Icons.send_rounded, color: AppTheme.brandPrimary, size: 14),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessageModel message) {
    final isUser = message.isUser;
    final isSpeaking = _currentlySpeakingId == message.id;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              margin: const EdgeInsets.only(right: 8, top: 2),
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppTheme.chipIndigoBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: AppTheme.brandPrimary, size: 16),
            ),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? AppTheme.brandPrimary : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                  bottomLeft: Radius.circular(isUser ? 10 : 2),
                  bottomRight: Radius.circular(isUser ? 2 : 10),
                ),
                border: isUser ? null : Border.all(color: AppTheme.brandBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Formatted Message Text with Vietnamese support
                  _buildFormattedText(message.text, isUser: isUser),

                  // Actions for AI message (TTS, Copy)
                  if (!isUser) ...[
                    const SizedBox(height: 10),
                    const Divider(height: 1, thickness: 0.5, color: AppTheme.brandBorder),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Nút phát âm / Dừng phát âm
                        InkWell(
                          onTap: () => _toggleTts(message.id, message.text),
                          borderRadius: BorderRadius.circular(6),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSpeaking ? const Color(0xFFFEE2E2) : AppTheme.chipIndigoBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isSpeaking ? Icons.stop_circle_rounded : Icons.volume_up_rounded,
                                  size: 15,
                                  color: isSpeaking ? const Color(0xFFDC2626) : AppTheme.brandPrimary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isSpeaking ? 'Dừng phát âm' : 'Phát âm',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: isSpeaking ? const Color(0xFFDC2626) : AppTheme.brandPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Nút sao chép
                        InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: message.text));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Đã sao chép câu trả lời vào bộ nhớ tạm'),
                                duration: Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.copy_rounded, size: 13, color: AppTheme.brandTextSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  'Sao chép',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.brandTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 4),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8, top: 2),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppTheme.chipIndigoBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: AppTheme.brandPrimary, size: 16),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.brandBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.brandPrimary),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'AI Tutor đang soạn câu trả lời...',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12.5,
                    color: AppTheme.brandTextSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: _stopGeneration,
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.stop_rounded, size: 14, color: Color(0xFFDC2626)),
                        const SizedBox(width: 3),
                        Text(
                          'Dừng',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppTheme.brandBorder, width: 1.0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              focusNode: _focusNode,
              maxLines: 4,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              enableSuggestions: true,
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                color: AppTheme.brandTextPrimary,
                height: 1.35,
              ),
              decoration: InputDecoration(
                hintText: 'Nhập câu hỏi cho AI Tutor...',
                hintStyle: GoogleFonts.beVietnamPro(
                  fontSize: 13.5,
                  color: AppTheme.brandTextMuted,
                ),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppTheme.brandBorder, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppTheme.brandBorder, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppTheme.brandPrimary, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: _isLoading
                ? _stopGeneration
                : () {
                    final text = _textController.text;
                    if (text.trim().isNotEmpty) {
                      _sendMessage(text);
                    }
                  },
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _isLoading ? const Color(0xFFDC2626) : AppTheme.brandPrimary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: _isLoading
                    ? const Icon(
                        Icons.stop_rounded,
                        color: Colors.white,
                        size: 24,
                      )
                    : const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Phân tích và hiển thị văn bản có định dạng markdown cơ bản
  Widget _buildFormattedText(String text, {required bool isUser}) {
    final defaultStyle = GoogleFonts.beVietnamPro(
      fontSize: 13.5,
      height: 1.5,
      color: isUser ? Colors.white : AppTheme.brandTextPrimary,
    );

    if (isUser) {
      return Text(text, style: defaultStyle);
    }

    // Tách dòng để render danh sách và đoạn văn
    final lines = text.split('\n');
    final List<Widget> widgets = [];

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        widgets.add(const SizedBox(height: 6));
        continue;
      }

      // Loại bỏ hoàn toàn các dòng gạch nối ngang (--- hoặc *** hoặc ___)
      if (RegExp(r'^[-*_]{2,}$').hasMatch(trimmed)) {
        widgets.add(const SizedBox(height: 6));
        continue;
      }

      // Xử lý tiêu đề Markdown (### hoặc ##)
      if (line.startsWith('### ') || line.startsWith('## ') || line.startsWith('# ')) {
        final headingText = line.replaceAll(RegExp(r'^#+\s*'), '');
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Text(
              headingText,
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.bold,
                fontSize: 14.5,
                color: AppTheme.brandPrimary,
              ),
            ),
          ),
        );
        continue;
      }

      // Xử lý gạch đầu dòng (- hoặc *)
      final isBullet = line.trimLeft().startsWith('- ') || line.trimLeft().startsWith('* ');
      final content = isBullet ? line.trimLeft().substring(2) : line;

      final spans = _parseMarkdownSpans(content, isUser: isUser);

      if (isBullet) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 6, bottom: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandPrimary,
                  ),
                ),
                Expanded(child: RichText(text: TextSpan(children: spans, style: defaultStyle))),
              ],
            ),
          ),
        );
      } else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: RichText(text: TextSpan(children: spans, style: defaultStyle)),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  List<TextSpan> _parseMarkdownSpans(String text, {required bool isUser}) {
    final List<TextSpan> spans = [];
    final pattern = RegExp(r'(\*\*.*?\*\*)|(\*.*?\*)|(`.*?`)');
    int lastIndex = 0;

    for (final match in pattern.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
      }

      final matchedText = match.group(0)!;
      if (matchedText.startsWith('**') && matchedText.endsWith('**') && matchedText.length >= 4) {
        spans.add(
          TextSpan(
            text: matchedText.substring(2, matchedText.length - 2),
            style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold),
          ),
        );
      } else if (matchedText.startsWith('*') && matchedText.endsWith('*') && matchedText.length >= 2) {
        spans.add(
          TextSpan(
            text: matchedText.substring(1, matchedText.length - 1),
            style: GoogleFonts.beVietnamPro(fontStyle: FontStyle.italic),
          ),
        );
      } else if (matchedText.startsWith('`') && matchedText.endsWith('`') && matchedText.length >= 2) {
        spans.add(
          TextSpan(
            text: matchedText.substring(1, matchedText.length - 1),
            style: TextStyle(
              backgroundColor: isUser ? Colors.black26 : const Color(0xFFF3F4F6),
              fontFamily: 'monospace',
              fontSize: 12,
            ),
          ),
        );
      } else {
        spans.add(TextSpan(text: matchedText));
      }
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex)));
    }

    return spans;
  }
}
