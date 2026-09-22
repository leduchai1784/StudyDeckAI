import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../models/user_custom_deck.dart';
import '../../../services/flashcard_progress_service.dart';

class CreateFlashcardScreen extends StatefulWidget {
  final String? preselectedDeckId;

  const CreateFlashcardScreen({
    super.key,
    this.preselectedDeckId,
  });

  @override
  State<CreateFlashcardScreen> createState() => _CreateFlashcardScreenState();
}

class _CreateFlashcardScreenState extends State<CreateFlashcardScreen> {
  final _formKey = GlobalKey<FormState>();
  final FlashcardProgressService _progressService = FlashcardProgressService();

  final _titleController = TextEditingController();
  final _viwordController = TextEditingController();
  final _transcriptionController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _videscriptionController = TextEditingController();
  final _exampleController = TextEditingController();

  List<UserCustomDeck> _decks = [];
  String? _selectedDeckId;
  bool _isLoadingDecks = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadDecks();
  }

  Future<void> _loadDecks() async {
    final decks = await _progressService.getCustomDecks();
    if (mounted) {
      setState(() {
        _decks = decks;
        if (widget.preselectedDeckId != null &&
            decks.any((d) => d.id == widget.preselectedDeckId)) {
          _selectedDeckId = widget.preselectedDeckId;
        } else if (decks.isNotEmpty) {
          _selectedDeckId = decks.first.id;
        }
        _isLoadingDecks = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _viwordController.dispose();
    _transcriptionController.dispose();
    _descriptionController.dispose();
    _videscriptionController.dispose();
    _exampleController.dispose();
    super.dispose();
  }

  Future<void> _quickCreateDeck() async {
    final nameController = TextEditingController();

    final created = await showDialog<UserCustomDeck>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.brandSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Tạo Deck mới', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppTheme.brandTextPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nhập tên bộ thẻ bạn muốn lưu:', style: TextStyle(fontSize: 13, color: AppTheme.brandTextSecondary)),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Ví dụ: IELTS Speaking, Giao tiếp...',
                filled: true,
                fillColor: AppTheme.brandBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppTheme.brandBorder)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppTheme.brandBorder)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppTheme.brandPrimary, width: 1.5)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Huỷ', style: TextStyle(color: AppTheme.brandTextSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                final newDeck = await _progressService.createCustomDeck(name: name);
                if (ctx.mounted) Navigator.pop(ctx, newDeck);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.brandPrimary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Tạo Deck'),
          ),
        ],
      ),
    );

    if (created != null) {
      await _loadDecks();
      setState(() {
        _selectedDeckId = created.id;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    await _progressService.addCustomWord(
      title: _titleController.text,
      viword: _viwordController.text,
      transcription: _transcriptionController.text.isNotEmpty ? _transcriptionController.text : null,
      description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
      videscription: _videscriptionController.text.isNotEmpty ? _videscriptionController.text : null,
      example: _exampleController.text.isNotEmpty ? _exampleController.text : null,
      customDeckId: _selectedDeckId,
    );

    final selectedDeckName = _decks.firstWhere(
      (d) => d.id == _selectedDeckId,
      orElse: () => UserCustomDeck(id: '', name: 'Bộ thẻ', createdAt: DateTime.now()),
    ).name;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text('🎉 Đã thêm từ "${_titleController.text}" vào "$selectedDeckName"!'),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.brandSurface,
        elevation: 0,
        foregroundColor: AppTheme.brandTextPrimary,
        title: const Text(
          'Thêm Từ Vựng Mới',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.brandTextPrimary),
        ),
      ),
      body: _isLoadingDecks
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Note
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.chipIndigoBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.brandBorder),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.stars_rounded, color: AppTheme.brandPrimary, size: 22),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Chọn bộ thẻ muốn lưu và nhập thông tin từ vựng để luyện tập flashcard.',
                                style: TextStyle(fontSize: 13, color: AppTheme.brandTextPrimary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // 0. CHỌN DECK ĐỂ LƯU
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'CHỌN BỘ THẺ (DECK) MUỐN LƯU *',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.brandTextSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          InkWell(
                            onTap: _quickCreateDeck,
                            borderRadius: BorderRadius.circular(4),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              child: Row(
                                children: [
                                  Icon(Icons.add, size: 14, color: AppTheme.brandPrimary),
                                  SizedBox(width: 2),
                                  Text(
                                    '+ Tạo Deck mới',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.brandPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.brandSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.brandBorder),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedDeckId,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down, color: AppTheme.brandTextMuted),
                            items: _decks.map((deck) {
                              final deckColor = Color(deck.colorValue);
                              return DropdownMenuItem<String>(
                                value: deck.id,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: deckColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      deck.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (newId) {
                              if (newId != null) {
                                setState(() => _selectedDeckId = newId);
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // 1. Từ tiếng Anh
                      _buildInputField(
                        controller: _titleController,
                        label: 'Từ vựng Tiếng Anh *',
                        hint: 'Ví dụ: Resilient, Innovation, Perseverance...',
                        icon: Icons.font_download_outlined,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Vui lòng nhập từ tiếng Anh';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // 2. Nghĩa tiếng Việt
                      _buildInputField(
                        controller: _viwordController,
                        label: 'Nghĩa Tiếng Việt *',
                        hint: 'Ví dụ: Kiên cường, Sự đổi mới, Sự kiên trì...',
                        icon: Icons.translate_outlined,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Vui lòng nhập nghĩa tiếng Việt';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // 3. Phiên âm IPA
                      _buildInputField(
                        controller: _transcriptionController,
                        label: 'Phiên âm IPA (Tùy chọn)',
                        hint: 'Ví dụ: /rɪˈzɪliənt/',
                        icon: Icons.record_voice_over_outlined,
                      ),
                      const SizedBox(height: 16),

                      // 4. Định nghĩa Tiếng Anh
                      _buildInputField(
                        controller: _descriptionController,
                        label: 'Định nghĩa Tiếng Anh (Tùy chọn)',
                        hint: 'Ví dụ: able to withstand or recover quickly from difficult conditions',
                        icon: Icons.description_outlined,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),

                      // 5. Định nghĩa Tiếng Việt
                      _buildInputField(
                        controller: _videscriptionController,
                        label: 'Giải thích Tiếng Việt (Tùy chọn)',
                        hint: 'Ví dụ: có khả năng phục hồi nhanh chóng sau khó khăn',
                        icon: Icons.format_align_left_outlined,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),

                      // 6. Ví dụ câu
                      _buildInputField(
                        controller: _exampleController,
                        label: 'Ví dụ câu (Tùy chọn)',
                        hint: 'Ví dụ: She is resilient in the face of adversity.',
                        icon: Icons.chat_bubble_outline,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 28),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.brandPrimary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Lưu từ vựng',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.brandTextPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(fontSize: 14, color: AppTheme.brandTextPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppTheme.brandTextMuted, fontSize: 13),
            prefixIcon: Icon(icon, color: AppTheme.brandTextMuted, size: 20),
            filled: true,
            fillColor: AppTheme.brandSurface,
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
      ],
    );
  }
}
