import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../models/edu_word.dart';
import '../../../models/user_deck_progress.dart';
import '../../../services/eduwords_service.dart';
import '../../../services/flashcard_progress_service.dart';
import '../../../services/tts_service.dart';

class DeckListScreen extends StatefulWidget {
  const DeckListScreen({super.key});

  @override
  State<DeckListScreen> createState() => _DeckListScreenState();
}

class _DeckListScreenState extends State<DeckListScreen> {
  final EduwordsService _eduwordsService = EduwordsService();
  final FlashcardProgressService _progressService = FlashcardProgressService();
  final TtsService _ttsService = TtsService();

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = true;

  // Filter States: 'all' (Tất cả), 'decks' (Bộ thẻ), 'words' (Từ vựng)
  String _filterType = 'all';
  String? _selectedLevelFilter; // null / 'ALL', 'PERSONAL', 'A1', 'A2', 'B1', 'B2', 'C1', 'C2'
  String? _selectedStatusFilter; // null / 'ALL', 'IN_PROGRESS', 'COMPLETED', 'NOT_STARTED'

  Map<String, List<EduWord>> _groupedWords = {};
  Map<String, Set<int>> _masteredWordsMap = {};
  Map<String, UserDeckProgress> _deckProgressMap = {};
  Set<int> _favoriteWordIds = {};

  final List<Map<String, dynamic>> _levelDecksConfig = [
    {
      'level': 'PERSONAL',
      'levelLabel': 'Bộ thẻ Cá Nhân',
      'title': 'Bộ từ của bản thân',
      'badgeColor': AppTheme.tintPurpleBg,
      'badgeTextColor': AppTheme.tintPurpleText,
    },
    {
      'level': 'A1',
      'levelLabel': 'A1 - Cơ bản',
      'title': 'Từ vựng Cấp A1 - Sơ Cấp',
      'badgeColor': AppTheme.tintGreenBg,
      'badgeTextColor': AppTheme.tintGreenText,
    },
    {
      'level': 'A2',
      'levelLabel': 'A2 - Sơ cấp',
      'title': 'Từ vựng Cấp A2 - Sơ Trung Cấp',
      'badgeColor': AppTheme.tintIndigoBg,
      'badgeTextColor': AppTheme.tintIndigoText,
    },
    {
      'level': 'B1',
      'levelLabel': 'B1 - Trung cấp',
      'title': 'Từ vựng Cấp B1 - Trung Cấp',
      'badgeColor': AppTheme.chipIndigoBg,
      'badgeTextColor': AppTheme.brandPrimary,
    },
    {
      'level': 'B2',
      'levelLabel': 'B2 - Trung cao cấp',
      'title': 'Từ vựng Cấp B2 - Trung Cao Cấp',
      'badgeColor': AppTheme.tintAmberBg,
      'badgeTextColor': AppTheme.tintAmberText,
    },
    {
      'level': 'C1',
      'levelLabel': 'C1 - Cao cấp',
      'title': 'Từ vựng Cấp C1 - Cao Cấp',
      'badgeColor': AppTheme.tintPurpleBg,
      'badgeTextColor': AppTheme.tintPurpleText,
    },
    {
      'level': 'C2',
      'levelLabel': 'C2 - Tinh hoa',
      'title': 'Từ vựng Cấp C2 - Thành Thạo',
      'badgeColor': AppTheme.tintGreenBg,
      'badgeTextColor': AppTheme.tintGreenText,
    },
  ];

  @override
  void initState() {
    super.initState();
    _ttsService.init();
    _loadRealtimeData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRealtimeData() async {
    setState(() => _isLoading = true);
    final groupedData = await _eduwordsService.fetchWordsByLevel();
    final progressMap = await _progressService.getAllDeckProgress();
    final favoriteIds = await _progressService.getFavoriteWordIds();

    final Map<String, Set<int>> masteredMap = {};

    for (final key in groupedData.keys) {
      final masteredSet = await _progressService.getMasteredWordIds(key);
      masteredMap[key] = masteredSet;
    }

    if (mounted) {
      setState(() {
        _groupedWords = groupedData;
        _masteredWordsMap = masteredMap;
        _deckProgressMap = progressMap;
        _favoriteWordIds = favoriteIds;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(int wordId) async {
    final isStarred = await _progressService.toggleFavoriteWordId(wordId);
    if (mounted) {
      setState(() {
        if (isStarred) {
          _favoriteWordIds.add(wordId);
        } else {
          _favoriteWordIds.remove(wordId);
        }
      });
      // Tải lại để cập nhật bộ thẻ cá nhân nếu vừa thêm/bỏ từ sao
      _loadRealtimeData();
    }
  }

  // --- Filtering Decks & Words ---
  List<Map<String, dynamic>> _getFilteredDecks() {
    List<Map<String, dynamic>> list = _levelDecksConfig;

    // Lọc theo cấp độ
    if (_selectedLevelFilter != null && _selectedLevelFilter != 'ALL') {
      list = list.where((d) => (d['level'] as String).toUpperCase() == _selectedLevelFilter).toList();
    }

    // Lọc theo trạng thái
    if (_selectedStatusFilter != null && _selectedStatusFilter != 'ALL') {
      list = list.where((d) {
        final lvl = (d['level'] as String).toUpperCase();
        final progress = _deckProgressMap[lvl];
        final isCompleted = progress?.isCompleted ?? false;
        final isInProgress = progress != null && progress.status == DeckStatus.inProgress && !isCompleted;
        if (_selectedStatusFilter == 'COMPLETED') return isCompleted;
        if (_selectedStatusFilter == 'IN_PROGRESS') return isInProgress;
        if (_selectedStatusFilter == 'NOT_STARTED') return !isCompleted && !isInProgress;
        return true;
      }).toList();
    }

    if (_searchQuery.trim().isEmpty) return list;
    final q = _searchQuery.trim().toLowerCase();
    return list.where((deck) {
      final title = (deck['title'] as String).toLowerCase();
      final level = (deck['level'] as String).toLowerCase();
      final label = (deck['levelLabel'] as String).toLowerCase();
      return title.contains(q) || level.contains(q) || label.contains(q);
    }).toList();
  }

  List<EduWord> _getFilteredWords() {
    final List<EduWord> allWords = [];
    _groupedWords.forEach((levelKey, words) {
      if (_selectedLevelFilter == null ||
          _selectedLevelFilter == 'ALL' ||
          _selectedLevelFilter == levelKey.toUpperCase()) {
        allWords.addAll(words);
      }
    });

    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) {
      return allWords;
    }

    return allWords.where((w) {
      final title = w.title.toLowerCase();
      final viword = w.viword.toLowerCase();
      final transcription = w.transcription.toLowerCase();
      final example = w.example.toLowerCase();
      final description = w.description.toLowerCase();
      final videscription = w.videscription.toLowerCase();
      return title.contains(q) ||
          viword.contains(q) ||
          transcription.contains(q) ||
          example.contains(q) ||
          description.contains(q) ||
          videscription.contains(q);
    }).toList();
  }

  Map<String, Color> _getLevelBadgeColors(String level) {
    switch (level.toUpperCase()) {
      case 'PERSONAL':
        return {'bg': AppTheme.tintPurpleBg, 'text': AppTheme.tintPurpleText};
      case 'A1':
        return {'bg': AppTheme.tintGreenBg, 'text': AppTheme.tintGreenText};
      case 'A2':
        return {'bg': AppTheme.tintIndigoBg, 'text': AppTheme.tintIndigoText};
      case 'B1':
        return {'bg': AppTheme.chipIndigoBg, 'text': AppTheme.brandPrimary};
      case 'B2':
        return {'bg': AppTheme.tintAmberBg, 'text': AppTheme.tintAmberText};
      case 'C1':
        return {'bg': AppTheme.tintPurpleBg, 'text': AppTheme.tintPurpleText};
      case 'C2':
        return {'bg': AppTheme.tintGreenBg, 'text': AppTheme.tintGreenText};
      default:
        return {'bg': AppTheme.tintIndigoBg, 'text': AppTheme.brandPrimary};
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'IN_PROGRESS':
        return 'Đang học';
      case 'COMPLETED':
        return 'Đã hoàn thành';
      case 'NOT_STARTED':
        return 'Chưa học';
      default:
        return status;
    }
  }

  Future<void> _navigateToCreateCard() async {
    final res = await context.push<bool>('/personal-decks');
    if (res == true) {
      _loadRealtimeData();
    }
  }

  Future<void> _handleDeckTap(String level, String title, int totalCards) async {
    final upperKey = level.toUpperCase();

    // 0. PERSONAL DECK: Open Personal Decks management screen
    if (upperKey == 'PERSONAL') {
      final res = await context.push<bool>('/personal-decks');
      if (res == true) {
        _loadRealtimeData();
      }
      return;
    }

    final progress = _deckProgressMap[upperKey];

    // 1. DECK COMPLETED: Open DeckDetailScreen
    if (progress != null && progress.isCompleted) {
      await context.push(
        '/deck-detail',
        extra: {
          'deckId': upperKey,
          'deckTitle': title,
        },
      );
      _loadRealtimeData();
      return;
    }

    // 2. DECK IN PROGRESS: Prompt user to resume or restart
    if (progress != null && progress.status == DeckStatus.inProgress && progress.lastStudiedIndex > 0) {
      final resumeIndex = progress.lastStudiedIndex;
      final cardNumber = resumeIndex + 1;

      final choice = await showModalBottomSheet<String>(
        context: context,
        backgroundColor: AppTheme.surfaceContainerLowest,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (ctx) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Bạn đang học dở bộ thẻ này ($cardNumber/$totalCards thẻ). Bạn muốn tiếp tục hay học lại từ đầu?',
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(ctx, 'resume'),
                      icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                      label: Text('Tiếp tục học (Từ thẻ $cardNumber)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.brandPrimary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(ctx, 'restart'),
                      icon: const Icon(Icons.refresh_rounded, color: AppTheme.brandTextPrimary),
                      label: const Text('Học lại từ thẻ đầu tiên'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.brandTextPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppTheme.brandBorder),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      if (!mounted) return;
      if (choice == 'resume') {
        await context.push(
          '/flashcard-review',
          extra: {
            'level': upperKey,
            'levelTitle': title,
            'mode': 'study',
            'startIndex': resumeIndex,
          },
        );
        _loadRealtimeData();
      } else if (choice == 'restart') {
        await context.push(
          '/flashcard-review',
          extra: {
            'level': upperKey,
            'levelTitle': title,
            'mode': 'study',
            'startIndex': 0,
          },
        );
        _loadRealtimeData();
      }
      return;
    }

    // 3. NOT STARTED: Normal study from card 0
    if (!mounted) return;
    await context.push(
      '/flashcard-review',
      extra: {
        'level': upperKey,
        'levelTitle': title,
        'mode': 'study',
        'startIndex': 0,
      },
    );
    _loadRealtimeData();
  }

  // --- Filter Bottom Sheet Modal ---
  void _showFilterBottomSheet() {
    String tempFilterType = _filterType;
    String? tempLevel = _selectedLevelFilter ?? 'ALL';
    String? tempStatus = _selectedStatusFilter ?? 'ALL';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: AppTheme.brandSurface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle Bar
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.brandBorder,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.tune_rounded, color: AppTheme.brandPrimary, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Bộ Lọc Tìm Kiếm',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.brandTextPrimary,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20, color: AppTheme.brandTextSecondary),
                          onPressed: () => Navigator.pop(ctx),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // 1. Phân loại nội dung
                    const Text(
                      'HIỂN THỊ NỘI DUNG',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brandTextSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildFilterOptionChip(
                          label: 'Tất cả',
                          icon: Icons.grid_view_rounded,
                          isSelected: tempFilterType == 'all',
                          onTap: () => setModalState(() => tempFilterType = 'all'),
                        ),
                        _buildFilterOptionChip(
                          label: 'Bộ thẻ',
                          icon: Icons.collections_bookmark_rounded,
                          isSelected: tempFilterType == 'decks',
                          onTap: () => setModalState(() => tempFilterType = 'decks'),
                        ),
                        _buildFilterOptionChip(
                          label: 'Từ vựng',
                          icon: Icons.translate_rounded,
                          isSelected: tempFilterType == 'words',
                          onTap: () => setModalState(() => tempFilterType = 'words'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 2. Cấp độ / Bộ thẻ
                    const Text(
                      'CẤP ĐỘ / BỘ THẺ',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brandTextSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildFilterOptionChip(
                          label: 'Tất cả cấp độ',
                          isSelected: tempLevel == 'ALL',
                          onTap: () => setModalState(() => tempLevel = 'ALL'),
                        ),
                        _buildFilterOptionChip(
                          label: 'Cá nhân',
                          isSelected: tempLevel == 'PERSONAL',
                          onTap: () => setModalState(() => tempLevel = 'PERSONAL'),
                        ),
                        ...['A1', 'A2', 'B1', 'B2', 'C1', 'C2'].map((lvl) {
                          return _buildFilterOptionChip(
                            label: lvl,
                            isSelected: tempLevel == lvl,
                            onTap: () => setModalState(() => tempLevel = lvl),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 3. Trạng thái học
                    const Text(
                      'TRẠNG THÁI TIẾN ĐỘ',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brandTextSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildFilterOptionChip(
                          label: 'Tất cả trạng thái',
                          isSelected: tempStatus == 'ALL',
                          onTap: () => setModalState(() => tempStatus = 'ALL'),
                        ),
                        _buildFilterOptionChip(
                          label: 'Đang học',
                          isSelected: tempStatus == 'IN_PROGRESS',
                          onTap: () => setModalState(() => tempStatus = 'IN_PROGRESS'),
                        ),
                        _buildFilterOptionChip(
                          label: 'Đã hoàn thành',
                          isSelected: tempStatus == 'COMPLETED',
                          onTap: () => setModalState(() => tempStatus = 'COMPLETED'),
                        ),
                        _buildFilterOptionChip(
                          label: 'Chưa học',
                          isSelected: tempStatus == 'NOT_STARTED',
                          onTap: () => setModalState(() => tempStatus = 'NOT_STARTED'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Action buttons: Đặt lại & Áp dụng
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setModalState(() {
                                tempFilterType = 'all';
                                tempLevel = 'ALL';
                                tempStatus = 'ALL';
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.brandTextPrimary,
                              side: const BorderSide(color: AppTheme.brandBorder),
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Đặt lại', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _filterType = tempFilterType;
                                _selectedLevelFilter = tempLevel == 'ALL' ? null : tempLevel;
                                _selectedStatusFilter = tempStatus == 'ALL' ? null : tempStatus;
                              });
                              Navigator.pop(ctx);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.brandPrimary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Áp dụng', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterOptionChip({
    required String label,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.chipIndigoBg : AppTheme.brandBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.brandPrimary : AppTheme.brandBorder,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 15,
                color: isSelected ? AppTheme.brandPrimary : AppTheme.brandTextSecondary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppTheme.brandPrimary : AppTheme.brandTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Word Detail Modal ---
  void _showWordDetailModal(EduWord word) {
    final badgeColors = _getLevelBadgeColors(word.level);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            final isCurrentFav = _favoriteWordIds.contains(word.id);
            return Container(
              decoration: const BoxDecoration(
                color: AppTheme.brandSurface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle Bar
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.brandBorder,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Header Row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: badgeColors['bg'],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'CẤP ${word.level.toUpperCase()}',
                            style: TextStyle(
                              color: badgeColors['text'],
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            isCurrentFav ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: isCurrentFav ? AppTheme.brandAccent : AppTheme.brandTextSecondary,
                            size: 24,
                          ),
                          onPressed: () async {
                            await _toggleFavorite(word.id);
                            setModalState(() {});
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20, color: AppTheme.brandTextSecondary),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Word Title & Audio
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                word.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.brandTextPrimary,
                                ),
                              ),
                              if (word.transcription.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  word.formattedTranscription,
                                  style: AppTheme.ipaStyle(
                                    fontSize: 14.5,
                                    color: AppTheme.brandTextSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _ttsService.speak(word.title),
                          icon: const Icon(Icons.volume_up_rounded, size: 18),
                          label: const Text('Phát âm'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.chipIndigoBg,
                            foregroundColor: AppTheme.brandPrimary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: AppTheme.brandBorder, height: 1),
                    const SizedBox(height: 14),

                    // Meaning
                    const Text(
                      'NGHĨA TIẾNG VIỆT',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brandTextSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      word.viword,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brandPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Definition
                    if (word.description.isNotEmpty || word.videscription.isNotEmpty) ...[
                      const Text(
                        'GIẢI NGHĨA',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.brandTextSecondary,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (word.description.isNotEmpty)
                        Text(
                          word.description,
                          style: const TextStyle(fontSize: 13.5, color: AppTheme.brandTextPrimary, height: 1.35),
                        ),
                      if (word.videscription.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          word.videscription,
                          style: const TextStyle(fontSize: 13, color: AppTheme.brandTextSecondary, height: 1.35),
                        ),
                      ],
                      const SizedBox(height: 14),
                    ],

                    // Example
                    if (word.example.isNotEmpty) ...[
                      const Text(
                        'VÍ DỤ CÂU',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.brandTextSecondary,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.brandBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.brandBorder),
                        ),
                        child: Text(
                          word.example,
                          style: const TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: AppTheme.brandTextPrimary,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],

                    // Action Button: Học bộ thẻ này
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          final deckConfig = _levelDecksConfig.firstWhere(
                            (d) => (d['level'] as String).toUpperCase() == word.level.toUpperCase(),
                            orElse: () => _levelDecksConfig.first,
                          );
                          final title = deckConfig['title'] as String;
                          final count = _groupedWords[word.level.toUpperCase()]?.length ?? 0;
                          _handleDeckTap(word.level, title, count);
                        },
                        icon: const Icon(Icons.school_rounded, color: Colors.white, size: 18),
                        label: Text('Học bộ thẻ ${word.level.toUpperCase()}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.brandPrimary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- Word Card Item Widget ---
  Widget _buildWordCard(EduWord word) {
    final isFav = _favoriteWordIds.contains(word.id);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.brandSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.brandBorder),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showWordDetailModal(word),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Word title, Phonetic, Audio button, Favorite button
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              word.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.brandTextPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (word.transcription.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                word.formattedTranscription,
                                style: AppTheme.ipaStyle(
                                  fontSize: 13.5,
                                  color: AppTheme.brandTextSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded, color: AppTheme.brandPrimary, size: 21),
                      onPressed: () => _ttsService.speak(word.title),
                      tooltip: 'Phát âm',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: Icon(
                        isFav ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: isFav ? AppTheme.brandAccent : AppTheme.brandTextMuted,
                        size: 22,
                      ),
                      onPressed: () => _toggleFavorite(word.id),
                      tooltip: isFav ? 'Bỏ lưu' : 'Lưu từ này',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Vietnamese Meaning
                Text(
                  word.viword,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.brandPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Deck Card Item Widget ---
  Widget _buildDeckCard(Map<String, dynamic> deck) {
    final level = deck['level'] as String;
    final levelLabel = deck['levelLabel'] as String;
    final title = deck['title'] as String;
    final badgeColor = deck['badgeColor'] as Color;
    final badgeTextColor = deck['badgeTextColor'] as Color;

    final words = _groupedWords[level] ?? [];
    final count = words.length;

    final upperKey = level.toUpperCase();
    final progress = _deckProgressMap[upperKey];
    final isCompleted = progress?.isCompleted ?? false;
    final isInProgress = progress != null && progress.status == DeckStatus.inProgress && !isCompleted;

    // Progress calculation
    final double progressRatio = isCompleted
        ? 1.0
        : (isInProgress
            ? (progress.progress / 100.0).clamp(0.0, 1.0)
            : (count > 0 ? ((_masteredWordsMap[level]?.length ?? 0) / count) : 0.0));
    final int percent = (progressRatio * 100).round();

    // Status badge & color
    Color statusThemeColor = badgeTextColor;
    Widget? statusBadge;
    if (level != 'PERSONAL') {
      if (isCompleted) {
        statusThemeColor = AppTheme.brandSuccess;
        statusBadge = Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppTheme.tintGreenBg,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_rounded, color: AppTheme.brandSuccess, size: 12),
              SizedBox(width: 4),
              Text(
                'ĐÃ HOÀN THÀNH',
                style: TextStyle(
                  color: AppTheme.brandSuccess,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        );
      } else if (isInProgress) {
        statusThemeColor = AppTheme.brandAccent;
        statusBadge = Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppTheme.brandAccentLight,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'ĐANG HỌC',
            style: TextStyle(
              color: AppTheme.tintAmberText,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        );
      } else {
        statusBadge = Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppTheme.brandBackground,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppTheme.brandBorder),
          ),
          child: const Text(
            'CHƯA HỌC',
            style: TextStyle(
              color: AppTheme.brandTextSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.brandSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted ? AppTheme.brandSuccess.withValues(alpha: 0.4) : AppTheme.brandBorder,
          width: 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _handleDeckTap(level, title, count),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Badges Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        levelLabel,
                        style: TextStyle(
                          color: badgeTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    if (statusBadge != null) ...[
                      const SizedBox(width: 8),
                      statusBadge,
                    ],
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppTheme.brandTextMuted,
                      size: 14,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.brandTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),

                // Subtitle
                Text(
                  level == 'PERSONAL'
                      ? '$count thẻ'
                      : (isCompleted
                          ? '$count thẻ • Đã hoàn thành 100%'
                          : (isInProgress
                              ? '$count thẻ • Đã học ${progress.completedCards}/$count'
                              : '$count thẻ')),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.brandTextSecondary,
                  ),
                ),
                const SizedBox(height: 12),

                // If PERSONAL: Show "Thêm từ của bạn" button
                if (level == 'PERSONAL') ...[
                  InkWell(
                    onTap: _navigateToCreateCard,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.tintPurpleBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.tintPurpleText.withValues(alpha: 0.25),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle_outline_rounded,
                            size: 18,
                            color: AppTheme.tintPurpleText,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Thêm từ của bạn',
                            style: TextStyle(
                              color: AppTheme.tintPurpleText,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  // Progress Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tiến độ',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.brandTextSecondary,
                        ),
                      ),
                      Text(
                        '$percent%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusThemeColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: progressRatio,
                      minHeight: 5,
                      backgroundColor: AppTheme.brandBorder,
                      valueColor: AlwaysStoppedAnimation<Color>(statusThemeColor),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildRemovableFilterChip({
    required String label,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 4, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: AppTheme.chipIndigoBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.brandPrimary.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.brandPrimary,
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(12),
            child: const Padding(
              padding: EdgeInsets.all(2.0),
              child: Icon(Icons.close_rounded, size: 14, color: AppTheme.brandPrimary),
            ),
          ),
        ],
      ),
    );
  }

  // --- Views for Different Filter Modes ---
  Widget _buildDecksOnlyView(List<Map<String, dynamic>> decks) {
    if (decks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48.0),
          child: Column(
            children: [
              const Icon(Icons.search_off_rounded, size: 48, color: AppTheme.brandTextMuted),
              const SizedBox(height: 12),
              Text(
                _searchQuery.isNotEmpty
                    ? 'Không tìm thấy bộ thẻ phù hợp với "$_searchQuery"'
                    : 'Không có bộ thẻ nào phù hợp với bộ lọc đã chọn',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.brandTextSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Danh sách bộ thẻ (${decks.length})',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.brandTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: decks.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) => _buildDeckCard(decks[index]),
        ),
      ],
    );
  }

  Widget _buildWordsOnlyView(List<EduWord> words) {
    if (words.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48.0),
          child: Column(
            children: [
              const Icon(Icons.search_off_rounded, size: 48, color: AppTheme.brandTextMuted),
              const SizedBox(height: 12),
              Text(
                _searchQuery.isNotEmpty
                    ? 'Không tìm thấy từ vựng phù hợp với "$_searchQuery"'
                    : 'Không có từ vựng nào phù hợp với bộ lọc đã chọn',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.brandTextSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Danh sách từ vựng (${words.length} từ)',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.brandTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: words.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) => _buildWordCard(words[index]),
        ),
      ],
    );
  }

  Widget _buildAllContentView(List<Map<String, dynamic>> decks, List<EduWord> words) {
    final bool isFiltered = _searchQuery.isNotEmpty ||
        (_selectedLevelFilter != null && _selectedLevelFilter != 'ALL') ||
        (_selectedStatusFilter != null && _selectedStatusFilter != 'ALL');

    if (!isFiltered) {
      // Default initial view: All Flashcard Decks
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tất cả bộ thẻ cấp độ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppTheme.brandTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: decks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) => _buildDeckCard(decks[index]),
          ),
        ],
      );
    }

    // Filtered view: Shows matching decks AND matching words
    if (decks.isEmpty && words.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48.0),
          child: Column(
            children: [
              const Icon(Icons.search_off_rounded, size: 48, color: AppTheme.brandTextMuted),
              const SizedBox(height: 12),
              Text(
                'Không tìm thấy bộ thẻ hoặc từ vựng nào phù hợp với "$_searchQuery"',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.brandTextSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Matching Decks Section
        if (decks.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bộ thẻ (${decks.length})',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brandTextPrimary,
                ),
              ),
              if (_filterType == 'all')
                InkWell(
                  onTap: () => setState(() => _filterType = 'decks'),
                  child: const Text(
                    'Xem chỉ bộ thẻ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.brandPrimary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: decks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _buildDeckCard(decks[index]),
          ),
          const SizedBox(height: 24),
        ],

        // Matching Words Section
        if (words.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Từ vựng tìm thấy (${words.length} từ)',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brandTextPrimary,
                ),
              ),
              if (_filterType == 'all')
                InkWell(
                  onTap: () => setState(() => _filterType = 'words'),
                  child: const Text(
                    'Xem chỉ từ vựng',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.brandPrimary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: words.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) => _buildWordCard(words[index]),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredDecks = _getFilteredDecks();
    final filteredWords = _getFilteredWords();
    final hasActiveCustomFilters = (_selectedLevelFilter != null && _selectedLevelFilter != 'ALL') ||
        (_selectedStatusFilter != null && _selectedStatusFilter != 'ALL') ||
        _filterType != 'all';

    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bộ thẻ Flashcard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brandTextPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  InkWell(
                    onTap: _navigateToCreateCard,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.brandPrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 26),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 2. Search & Filter Bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.brandBorder),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => setState(() => _searchQuery = val),
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: _filterType == 'words'
                              ? 'Tìm từ vựng tiếng Anh, nghĩa tiếng Việt...'
                              : (_filterType == 'decks'
                                  ? 'Tìm bộ thẻ theo tên, cấp độ...'
                                  : 'Tìm kiếm từ vựng, bộ thẻ...'),
                          hintStyle: const TextStyle(color: AppTheme.brandTextMuted, fontSize: 13),
                          prefixIcon: const Icon(Icons.search, color: AppTheme.brandTextMuted, size: 20),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, color: AppTheme.brandTextSecondary, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Filter Tune Button
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: hasActiveCustomFilters ? AppTheme.chipIndigoBg : AppTheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: hasActiveCustomFilters ? AppTheme.brandPrimary : AppTheme.brandBorder,
                        width: hasActiveCustomFilters ? 1.5 : 1.0,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.tune,
                            color: hasActiveCustomFilters ? AppTheme.brandPrimary : AppTheme.brandTextPrimary,
                            size: 20,
                          ),
                          onPressed: _showFilterBottomSheet,
                          tooltip: 'Bộ lọc nâng cao',
                        ),
                        if (hasActiveCustomFilters)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppTheme.brandPrimary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (hasActiveCustomFilters) ...[
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (_filterType != 'all')
                        _buildRemovableFilterChip(
                          label: _filterType == 'decks' ? 'Lọc: Bộ thẻ' : 'Lọc: Từ vựng',
                          onRemove: () => setState(() => _filterType = 'all'),
                        ),
                      if (_selectedLevelFilter != null && _selectedLevelFilter != 'ALL') ...[
                        const SizedBox(width: 6),
                        _buildRemovableFilterChip(
                          label: 'Cấp: $_selectedLevelFilter',
                          onRemove: () => setState(() => _selectedLevelFilter = null),
                        ),
                      ],
                      if (_selectedStatusFilter != null && _selectedStatusFilter != 'ALL') ...[
                        const SizedBox(width: 6),
                        _buildRemovableFilterChip(
                          label: _getStatusLabel(_selectedStatusFilter!),
                          onRemove: () => setState(() => _selectedStatusFilter = null),
                        ),
                      ],
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => setState(() {
                          _filterType = 'all';
                          _selectedLevelFilter = null;
                          _selectedStatusFilter = null;
                        }),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          child: Text(
                            'Xóa lọc',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.brandPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // 4. Content Area: Loading / Filtered Content
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_filterType == 'decks')
                _buildDecksOnlyView(filteredDecks)
              else if (_filterType == 'words')
                _buildWordsOnlyView(filteredWords)
              else
                _buildAllContentView(filteredDecks, filteredWords),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
