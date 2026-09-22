import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../models/edu_word.dart';
import '../../../models/user_custom_deck.dart';
import '../../../services/flashcard_progress_service.dart';

class PersonalDecksScreen extends StatefulWidget {
  const PersonalDecksScreen({super.key});

  @override
  State<PersonalDecksScreen> createState() => _PersonalDecksScreenState();
}

class _PersonalDecksScreenState extends State<PersonalDecksScreen> {
  final FlashcardProgressService _progressService = FlashcardProgressService();

  bool _isLoading = true;
  List<UserCustomDeck> _decks = [];
  Map<String, List<EduWord>> _wordsByDeck = {};

  final List<Color> _presetColors = const [
    AppTheme.tintPurpleText, // 0xFF7C3AED (Purple)
    AppTheme.tintIndigoText, // 0xFF2563EB (Indigo)
    AppTheme.tintGreenText,  // 0xFF0F9D58 (Green)
    AppTheme.tintAmberText,  // 0xFFB45309 (Amber)
    AppTheme.brandPrimary,   // 0xFF4F46E5 (Primary)
    AppTheme.brandSuccess,   // 0xFF10B981 (Success Emerald)
  ];

  @override
  void initState() {
    super.initState();
    _loadDecksAndWords();
  }

  Future<void> _loadDecksAndWords() async {
    setState(() => _isLoading = true);

    final decks = await _progressService.getCustomDecks();
    final allCustomWords = await _progressService.getCustomWords();

    final Map<String, List<EduWord>> map = {};
    for (final deck in decks) {
      map[deck.id] = allCustomWords
          .where((w) => (w.customDeckId ?? 'default_personal') == deck.id)
          .toList();
    }

    if (mounted) {
      setState(() {
        _decks = decks;
        _wordsByDeck = map;
        _isLoading = false;
      });
    }
  }

  Future<void> _showCreateDeckSheet([UserCustomDeck? deckToEdit]) async {
    final nameController = TextEditingController(text: deckToEdit?.name ?? '');
    final descController = TextEditingController(text: deckToEdit?.description ?? '');
    int selectedColor = deckToEdit?.colorValue ?? _presetColors.first.toARGB32();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.outlineVariant.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    deckToEdit == null ? 'Tạo Bộ Thẻ (Deck) Mới' : 'Chỉnh Sửa Bộ Thẻ',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Tạo không gian riêng để lưu từ vựng theo từng chủ đề hoặc mục tiêu học tập.',
                    style: TextStyle(fontSize: 13, color: AppTheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 18),

                  // Tên Deck
                  const Text(
                    'TÊN BỘ THẺ *',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.outline),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: nameController,
                    autofocus: deckToEdit == null,
                    decoration: InputDecoration(
                      hintText: 'Ví dụ: IELTS Speaking, Giao tiếp hàng ngày...',
                      hintStyle: const TextStyle(fontSize: 14, color: AppTheme.outline),
                      filled: true,
                      fillColor: AppTheme.surfaceContainerLow,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppTheme.outlineVariant.withValues(alpha: 0.4)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppTheme.outlineVariant.withValues(alpha: 0.4)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.brandPrimary, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Mô tả Deck
                  const Text(
                    'MÔ TẢ / CHỦ ĐỀ',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.brandTextSecondary),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: descController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Nhập ghi chú hoặc mô tả ngắn...',
                      hintStyle: const TextStyle(fontSize: 14, color: AppTheme.brandTextMuted),
                      filled: true,
                      fillColor: AppTheme.brandBackground,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.brandBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.brandBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.brandPrimary, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Chọn màu đại diện
                  const Text(
                    'MÀU ĐẠI DIỆN',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.outline),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: _presetColors.map((color) {
                      final val = color.toARGB32();
                      final isSelected = selectedColor == val;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: InkWell(
                          onTap: () => setSheetState(() => selectedColor = val),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(8),
                              border: isSelected
                                  ? Border.all(color: Colors.black87, width: 2.5)
                                  : Border.all(color: Colors.white, width: 1.5),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: color.withValues(alpha: 0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, color: Colors.white, size: 18)
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 22),

                  // Nút Lưu
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final name = nameController.text.trim();
                        if (name.isEmpty) return;

                        Navigator.pop(ctx);

                        if (deckToEdit == null) {
                          await _progressService.createCustomDeck(
                            name: name,
                            description: descController.text.trim(),
                            colorValue: selectedColor,
                          );
                        } else {
                          final all = await _progressService.getCustomDecks();
                          final idx = all.indexWhere((d) => d.id == deckToEdit.id);
                          if (idx != -1) {
                            all[idx] = deckToEdit.copyWith(
                              name: name,
                              description: descController.text.trim(),
                              colorValue: selectedColor,
                            );
                            await _progressService.saveCustomDecks(all);
                          }
                        }
                        _loadDecksAndWords();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.brandPrimary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        deckToEdit == null ? 'Tạo Bộ Thẻ Mới' : 'Lưu Thay Đổi',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _navigateToAddWord([String? deckId]) async {
    final res = await context.push<bool>(
      '/create-flashcard',
      extra: {'preselectedDeckId': deckId},
    );
    if (res == true) {
      _loadDecksAndWords();
    }
  }

  void _reviewDeck(UserCustomDeck deck, List<EduWord> words) {
    if (words.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bộ thẻ "${deck.name}" chưa có từ nào. Hãy thêm từ vựng trước nhé!'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Thêm ngay',
            textColor: Colors.amber,
            onPressed: () => _navigateToAddWord(deck.id),
          ),
        ),
      );
      return;
    }

    context.push(
      '/flashcard-review',
      extra: {
        'level': 'PERSONAL',
        'levelTitle': deck.name,
        'mode': 'study',
        'customWords': words,
      },
    ).then((_) => _loadDecksAndWords());
  }

  Future<void> _confirmDeleteDeck(UserCustomDeck deck) async {
    final words = _wordsByDeck[deck.id] ?? [];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text('Xoá bộ thẻ "${deck.name}"?'),
        content: Text(
          words.isNotEmpty
              ? 'Bộ thẻ này đang chứa ${words.length} từ vựng. Bạn có chắc chắn muốn xoá bộ thẻ này không?'
              : 'Bạn có chắc chắn muốn xoá bộ thẻ này không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Huỷ'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _progressService.deleteCustomDeck(deck.id);
      _loadDecksAndWords();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.brandSurface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.brandTextPrimary),
          onPressed: () => context.pop(true),
        ),
        title: const Text(
          'Bộ thẻ của bạn',
          style: TextStyle(
            color: AppTheme.brandTextPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.create_new_folder_outlined, color: AppTheme.brandPrimary),
            tooltip: 'Tạo Deck mới',
            onPressed: () => _showCreateDeckSheet(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Info Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.brandPrimary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'QUẢN LÝ BỘ THẺ CÁ NHÂN',
                                  style: TextStyle(
                                    color: AppTheme.brandPrimaryLight,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${_decks.length} Bộ thẻ • ${_wordsByDeck.values.fold<int>(0, (sum, list) => sum + list.length)} từ vựng',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Tạo các bộ thẻ theo chủ đề và chọn bộ thẻ bạn muốn lưu khi thêm từ.',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Quick Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _showCreateDeckSheet(),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('Tạo Deck mới'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.brandPrimary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _navigateToAddWord(),
                            icon: const Icon(Icons.post_add_rounded, size: 18, color: AppTheme.brandTextPrimary),
                            label: const Text(
                              'Thêm từ vựng',
                              style: TextStyle(color: AppTheme.brandTextPrimary, fontWeight: FontWeight.bold),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppTheme.brandBorder),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),

                    // Section Title
                    const Text(
                      'DANH SÁCH BỘ THẺ CỦA BẠN',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brandTextSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Decks List
                    if (_decks.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Text('Chưa có bộ thẻ nào. Hãy bấm "Tạo Deck mới" bên trên!'),
                        ),
                      )
                    else
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _decks.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final deck = _decks[index];
                          final words = _wordsByDeck[deck.id] ?? [];
                          final deckColor = Color(deck.colorValue);

                          return Container(
                            decoration: BoxDecoration(
                              color: AppTheme.brandSurface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.brandBorder),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Deck Header Row
                                  Row(
                                    children: [
                                      Container(
                                        width: 38,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          color: deckColor.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(Icons.folder_special_rounded, color: deckColor, size: 22),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              deck.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.brandTextPrimary,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              deck.description.isNotEmpty
                                                  ? deck.description
                                                  : 'Tạo lúc: ${deck.createdAt.day}/${deck.createdAt.month}/${deck.createdAt.year}',
                                              style: const TextStyle(fontSize: 12, color: AppTheme.brandTextSecondary),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert, size: 20, color: AppTheme.brandTextMuted),
                                        onSelected: (val) {
                                          if (val == 'edit') {
                                            _showCreateDeckSheet(deck);
                                          } else if (val == 'delete') {
                                            _confirmDeleteDeck(deck);
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            value: 'edit',
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit_outlined, size: 18),
                                                SizedBox(width: 8),
                                                Text('Đổi tên & mô tả'),
                                              ],
                                            ),
                                          ),
                                          if (_decks.length > 1)
                                            const PopupMenuItem(
                                              value: 'delete',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.delete_outline, size: 18, color: AppTheme.brandError),
                                                  SizedBox(width: 8),
                                                  Text('Xoá bộ thẻ', style: TextStyle(color: AppTheme.brandError)),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Badge & Word Count Row
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: deckColor.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          '${words.length} thẻ từ vựng',
                                          style: TextStyle(
                                            color: deckColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),

                                  // Actions Row: [ Học bộ này ] + [ + Thêm từ ]
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () => _reviewDeck(deck, words),
                                          icon: const Icon(Icons.play_arrow_rounded, size: 18, color: Colors.white),
                                          label: const Text(
                                            'Học bộ này',
                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: deckColor,
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      OutlinedButton.icon(
                                        onPressed: () => _navigateToAddWord(deck.id),
                                        icon: const Icon(Icons.add, size: 16, color: AppTheme.brandTextPrimary),
                                        label: const Text(
                                          'Thêm từ',
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.brandTextPrimary),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                          side: const BorderSide(color: AppTheme.brandBorder),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
