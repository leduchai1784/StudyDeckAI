import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../models/nks_user.dart';
import '../../../models/user_deck_progress.dart';
import '../../../services/flashcard_progress_service.dart';
import '../../../services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final FlashcardProgressService _progressService = FlashcardProgressService();

  NksUserModel? _nksUser;
  bool _isLoading = true;

  double _targetBand = 6.5;
  double _learningProgress = 68.0;
  int _streakDays = 1;
  int _savedWordsCount = 280;
  List<QuizSession> _recentQuizHistory = [];
  Set<int> _studiedDaysInMonth = {};

  final List<double> _availableBands = [
    5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0,
  ];

  double get _currentBand {
    if (_learningProgress >= 100.0) {
      return _targetBand;
    }
    final raw = _targetBand * (_learningProgress / 100.0);
    final val = double.parse(raw.toStringAsFixed(1));
    return val >= _targetBand ? (_targetBand > 0.1 ? _targetBand - 0.1 : 0.0) : val;
  }

  @override
  void initState() {
    super.initState();
    _loadAllProfileData();
  }

  Future<void> _loadAllProfileData() async {
    setState(() => _isLoading = true);

    // 1. User Info from API
    try {
      final res = await _userService.getUserInfo();
      if (res['success'] == true) {
        final userMap = _userService.parseUserData(res);
        if (userMap != null) {
          _nksUser = NksUserModel.fromJson(userMap);
        }
      }
    } catch (_) {}

    // 2. Target Band & Stats from FlashcardProgressService
    final now = DateTime.now();
    final band = await _progressService.getTargetBand();
    final streak = await _progressService.getStreakDays();
    final wordsCount = await _progressService.getTotalMasteredAndCustomWordsCount();
    final quizSessions = await _progressService.getQuizSessions('A1');
    final studiedDays = await _progressService.getStudiedDaysForMonth(now.year, now.month);
    final learningProg = await _progressService.getOverallLearningProgress();

    if (mounted) {
      setState(() {
        _targetBand = band;
        _learningProgress = learningProg;
        _streakDays = streak;
        _savedWordsCount = wordsCount > 0 ? wordsCount : 280;
        _recentQuizHistory = quizSessions;
        _studiedDaysInMonth = studiedDays;
        _isLoading = false;
      });
    }
  }

  Future<void> _onSelectBand(double band) async {
    await _progressService.setTargetBand(band);
    if (mounted) {
      setState(() => _targetBand = band);
    }
  }

  void _showQuizHistoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.brandSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.brandBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Lịch Sử Học Tập & Kiểm Tra',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandTextPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                if (_recentQuizHistory.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'Chưa có kết quả bài kiểm tra nào gần đây.',
                        style: TextStyle(color: AppTheme.brandTextSecondary),
                      ),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _recentQuizHistory.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, color: AppTheme.brandBorder),
                      itemBuilder: (context, index) {
                        final q = _recentQuizHistory[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: q.score >= 70 ? AppTheme.tintGreenBg : AppTheme.brandAccentLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              q.score >= 70 ? Icons.check_circle : Icons.quiz_outlined,
                              color: q.score >= 70 ? AppTheme.tintGreenText : AppTheme.tintAmberText,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            'Bài test ${q.deckId}: ${q.score.toInt()}/100 điểm',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.brandTextPrimary),
                          ),
                          subtitle: Text(
                            'Đúng ${q.correctAnswers}/${q.totalQuestions} câu • ${q.completedAt.day}/${q.completedAt.month}/${q.completedAt.year}',
                            style: const TextStyle(fontSize: 12, color: AppTheme.brandTextSecondary),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Hồ Sơ Cá Nhân',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.brandTextPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppTheme.brandTextPrimary),
            tooltip: 'Cài đặt tài khoản',
            onPressed: () async {
              await context.push('/settings');
              _loadAllProfileData();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
                child: Column(
                  children: [
                    // 1. User Header Card
                    _buildUserHeaderCard(),
                    const SizedBox(height: 14),

                    // 2. Top 3 Stats Pill Row: [ Band 6.0 ] [ 68% ] [ 7 Ngày ]
                    _buildTopStatsRow(),
                    const SizedBox(height: 14),

                    // 3. Manifest Band Điểm Card
                    _buildManifestBandCard(),
                    const SizedBox(height: 14),

                    // 4. Chuỗi Ngày Học Card
                    _buildStreakWeekCard(),
                    const SizedBox(height: 14),

                    // 5. Kỹ Năng Gần Đây Card
                    _buildRecentSkillsCard(),
                    const SizedBox(height: 14),

                    // 6. Navigation Action Items
                    _buildMenuActionItem(
                      icon: Icons.bookmark_rounded,
                      iconBg: AppTheme.chipIndigoBg,
                      iconColor: AppTheme.chipIndigoText,
                      title: 'Từ Vựng Đã Lưu',
                      subtitle: '$_savedWordsCount bộ từ vựng và thẻ học đã ghi nhớ',
                      onTap: () async {
                        await context.push('/personal-decks');
                        _loadAllProfileData();
                      },
                    ),
                    const SizedBox(height: 10),

                    _buildMenuActionItem(
                      icon: Icons.history_rounded,
                      iconBg: AppTheme.tintGreenBg,
                      iconColor: AppTheme.tintGreenText,
                      title: 'Lịch Sử Học Tập & Tiến Độ',
                      subtitle: 'Nhật ký bài học và điểm kiểm tra',
                      onTap: _showQuizHistoryBottomSheet,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  // 1. User Header Card
  Widget _buildUserHeaderCard() {
    return InkWell(
      onTap: () async {
        await context.push('/edit-profile');
        _loadAllProfileData();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.brandSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.brandBorder),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: AppTheme.tintIndigoBg,
              backgroundImage: _nksUser?.formattedAvatarUrl != null
                  ? NetworkImage(_nksUser!.formattedAvatarUrl!)
                  : null,
              child: _nksUser?.formattedAvatarUrl == null
                  ? const Icon(Icons.person, size: 36, color: AppTheme.tintIndigoText)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _nksUser?.fullName ?? 'Thành viên StudyDeck',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brandTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _nksUser?.email ?? 'hocvien@studydeck.ai',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppTheme.brandTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.brandAccentLight,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.brandAccent.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, size: 13, color: AppTheme.tintAmberText),
                            const SizedBox(width: 4),
                            Text(
                              'Target ${_targetBand.toStringAsFixed(1)}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.tintAmberText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.tintGreenBg,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.brandSuccess.withValues(alpha: 0.3)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_rounded, size: 12, color: AppTheme.tintGreenText),
                            SizedBox(width: 4),
                            Text(
                              'Gói Free',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.tintGreenText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.brandTextSecondary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  // 2. Top 3 Stats Pill Row: [ Điểm hiện tại (Blue) ] [ Lộ trình học (Green) ] [ Streak (Amber) ]
  Widget _buildTopStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildTopStatPill(
            title: 'Điểm hiện tại',
            icon: Icons.school_rounded,
            pillText: 'Band ${_currentBand.toStringAsFixed(1)}',
            badgeBg: AppTheme.tintIndigoBg,
            badgeTextColor: AppTheme.tintIndigoText,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildTopStatPill(
            title: 'Lộ trình học',
            icon: Icons.trending_up_rounded,
            pillText: '${_learningProgress.toInt()}%',
            badgeBg: AppTheme.tintGreenBg,
            badgeTextColor: AppTheme.tintGreenText,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildTopStatPill(
            title: 'Streak',
            icon: Icons.local_fire_department_rounded,
            pillText: '$_streakDays Ngày',
            badgeBg: AppTheme.brandAccentLight,
            badgeTextColor: AppTheme.tintAmberText,
          ),
        ),
      ],
    );
  }

  Widget _buildTopStatPill({
    required String title,
    required String pillText,
    IconData? icon,
    required Color badgeBg,
    required Color badgeTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.brandSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.brandBorder),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppTheme.brandTextSecondary,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 14,
                    color: icon == Icons.local_fire_department_rounded
                        ? AppTheme.brandAccent
                        : badgeTextColor,
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  pillText,
                  style: TextStyle(
                    color: badgeTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. Manifest Band Điểm Card
  Widget _buildManifestBandCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.brandSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.brandBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'MANIFEST BAND ĐIỂM',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brandTextSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.tintIndigoBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.flag_rounded, size: 13, color: AppTheme.tintIndigoText),
                    SizedBox(width: 4),
                    Text(
                      'Mục tiêu',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.tintIndigoText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                _targetBand.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brandTextPrimary,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 14),
              PopupMenuButton<double>(
                initialValue: _targetBand,
                tooltip: 'Chọn band điểm',
                position: PopupMenuPosition.under,
                offset: const Offset(0, 6),
                color: AppTheme.brandSurface,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppTheme.brandBorder),
                ),
                onSelected: _onSelectBand,
                itemBuilder: (BuildContext context) {
                  return _availableBands.map((band) {
                    final isSelected = band == _targetBand;
                    return PopupMenuItem<double>(
                      value: band,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Band ${band.toStringAsFixed(1)}',
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? AppTheme.brandPrimary : AppTheme.brandTextPrimary,
                              fontSize: 13.5,
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_rounded, color: AppTheme.brandPrimary, size: 18),
                        ],
                      ),
                    );
                  }).toList();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppTheme.brandPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Chọn band',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Đặt mục tiêu band điểm và để StudyDeck AI đồng hành cùng bạn mỗi ngày 🎯',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.brandTextSecondary,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  // 4. Chuỗi Ngày Học Card
  Widget _buildStreakWeekCard() {
    final daysOfWeek = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    final now = DateTime.now();
    final todayWeekdayIndex = now.weekday - 1; // 0: T2 ... 6: CN
    final monday = DateTime(now.year, now.month, now.day).subtract(Duration(days: todayWeekdayIndex));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.brandSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.brandBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'CHUỖI NGÀY HỌC',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brandTextSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              InkWell(
                onTap: _showMonthlyActivityModal,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.chipIndigoBg,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppTheme.brandPrimary.withValues(alpha: 0.15)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 14,
                        color: AppTheme.brandPrimary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Lịch tháng',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.brandPrimary,
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 14,
                        color: AppTheme.brandPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$_streakDays ',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brandTextPrimary,
                ),
              ),
              const Text(
                'ngày liên tiếp',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.brandTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 7 Days Circles Row (T2 -> CN)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final isToday = index == todayWeekdayIndex;
              final dayDate = monday.add(Duration(days: index));
              final isStudied = (dayDate.month == now.month && _studiedDaysInMonth.contains(dayDate.day)) ||
                  (isToday && _streakDays > 0);
              final dayName = daysOfWeek[index];
              final isSun = dayName == 'CN';
              final isFuture = dayDate.isAfter(now);

              return Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isStudied
                          ? AppTheme.brandAccentLight
                          : (isToday ? AppTheme.chipIndigoBg : AppTheme.brandBackground),
                      border: isStudied
                          ? Border.all(color: AppTheme.brandAccent, width: 1.8)
                          : (isToday
                              ? Border.all(color: AppTheme.brandPrimary, width: 1.8)
                              : Border.all(color: AppTheme.brandBorder)),
                    ),
                    child: isStudied
                        ? const Center(
                            child: Icon(
                              Icons.local_fire_department_rounded,
                              size: 18,
                              color: AppTheme.brandAccent,
                            ),
                          )
                        : (isToday
                            ? const Center(
                                child: Text(
                                  '•',
                                  style: TextStyle(
                                    color: AppTheme.brandPrimary,
                                    fontSize: 20,
                                    height: 1.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : null),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dayName,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: (isToday || isStudied) ? FontWeight.bold : FontWeight.w500,
                      color: isStudied
                          ? AppTheme.brandAccent
                          : (isToday
                              ? AppTheme.brandPrimary
                              : (isSun
                                  ? AppTheme.brandError
                                  : (isFuture ? AppTheme.brandTextMuted : AppTheme.brandTextSecondary))),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // 5. Kỹ Năng Gần Đây Card
  Widget _buildRecentSkillsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.brandSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.brandBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'KỸ NĂNG GẦN ĐÂY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brandTextSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                'band /9',
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.brandTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          _buildSkillRow('Reading', 6.5, AppTheme.brandSuccess),
          const SizedBox(height: 10),
          _buildSkillRow('Writing', 6.0, AppTheme.tintPurpleText),
          const SizedBox(height: 10),
          _buildSkillRow('Listening', 7.0, AppTheme.tintIndigoText),
          const SizedBox(height: 10),
          _buildSkillRow('Speaking', 6.5, AppTheme.tintAmberText),

          const SizedBox(height: 14),
          const Divider(height: 1, color: AppTheme.brandBorder),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'Tổng 1 bài đã làm',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.brandTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillRow(String skillName, double band, Color color) {
    final ratio = (band / 9.0).clamp(0.0, 1.0);

    return Row(
      children: [
        SizedBox(
          width: 76,
          child: Text(
            skillName,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.brandTextPrimary,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6,
              backgroundColor: AppTheme.brandBackground,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Container(
          width: 12,
          height: 2.5,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  // 6. Modal Lịch Hoạt Động Theo Các Tháng
  void _showMonthlyActivityModal() {
    DateTime displayMonth = DateTime(DateTime.now().year, DateTime.now().month);
    Set<int> monthStudiedDays = Set.from(_studiedDaysInMonth);
    bool isLoadingMonth = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            final now = DateTime.now();
            final isCurrentMonth = displayMonth.year == now.year && displayMonth.month == now.month;
            final currentDay = isCurrentMonth ? now.day : -1;
            final totalDaysInMonth = DateTime(displayMonth.year, displayMonth.month + 1, 0).day;
            final firstDayWeekday = DateTime(displayMonth.year, displayMonth.month, 1).weekday; // 1: T2 ... 7: CN
            final weekLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

            Future<void> changeMonth(int offset) async {
              setModalState(() => isLoadingMonth = true);
              final newMonth = DateTime(displayMonth.year, displayMonth.month + offset);
              final days = await _progressService.getStudiedDaysForMonth(newMonth.year, newMonth.month);
              if (ctx.mounted) {
                setModalState(() {
                  displayMonth = newMonth;
                  monthStudiedDays = days;
                  isLoadingMonth = false;
                });
              }
            }

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.calendar_month_rounded, color: AppTheme.brandPrimary, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Lịch Hoạt Động Học Tập',
                              style: TextStyle(
                                fontSize: 16,
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
                    const SizedBox(height: 16),

                    // Month Navigation Selector
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.brandBackground,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.brandBorder),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left_rounded, color: AppTheme.brandTextPrimary, size: 22),
                            onPressed: isLoadingMonth ? null : () => changeMonth(-1),
                            tooltip: 'Tháng trước',
                          ),
                          Text(
                            'Tháng ${displayMonth.month} · Năm ${displayMonth.year}',
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.brandTextPrimary,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right_rounded, color: AppTheme.brandTextPrimary, size: 22),
                            onPressed: isLoadingMonth ? null : () => changeMonth(1),
                            tooltip: 'Tháng sau',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Calendar Grid Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.brandSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.brandBorder),
                      ),
                      child: Column(
                        children: [
                          // Week Header
                          Row(
                            children: weekLabels.map((lbl) {
                              final isSun = lbl == 'CN';
                              return Expanded(
                                child: Center(
                                  child: Text(
                                    lbl,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isSun ? AppTheme.brandError : AppTheme.brandTextSecondary,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 10),

                          // Calendar Matrix or Loading Spinner
                          isLoadingMonth
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 36.0),
                                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                )
                              : _buildCalendarDaysMatrix(firstDayWeekday, totalDaysInMonth, currentDay, monthStudiedDays),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Stats Summary Footer
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.brandAccentLight,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.brandAccent.withValues(alpha: 0.25)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.local_fire_department_rounded, color: AppTheme.brandAccent, size: 22),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$_streakDays ngày',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.tintAmberText,
                                        ),
                                      ),
                                      const Text(
                                        'Streak hiện tại',
                                        style: TextStyle(fontSize: 11, color: AppTheme.tintAmberText),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.chipIndigoBg,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.brandPrimary.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.local_fire_department_rounded, color: AppTheme.brandPrimary, size: 22),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${monthStudiedDays.length} ngày',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.brandPrimary,
                                        ),
                                      ),
                                      Text(
                                        'Đã học tháng ${displayMonth.month}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 11, color: AppTheme.brandPrimary),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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

  Widget _buildCalendarDaysMatrix(
    int startOffset,
    int totalDays,
    int currentDay,
    Set<int> studiedDays,
  ) {
    final List<Widget> dayWidgets = [];

    // Empty spaces before first day (startOffset is 1-based: 1=Mon...7=Sun)
    final leadingEmpty = startOffset - 1;
    for (int i = 0; i < leadingEmpty; i++) {
      dayWidgets.add(const SizedBox(width: 28, height: 28));
    }

    // Days in month
    for (int day = 1; day <= totalDays; day++) {
      final isToday = day == currentDay;
      final isStudied = studiedDays.contains(day);

      dayWidgets.add(
        Center(
          child: Tooltip(
            message: isStudied ? 'Ngày $day: Đã học' : (isToday ? 'Hôm nay (Ngày $day)' : 'Ngày $day'),
            child: Container(
              width: 28,
              height: 28,
              decoration: isStudied
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.brandAccentLight,
                      border: Border.all(
                        color: AppTheme.brandAccent,
                        width: isToday ? 2.0 : 1.2,
                      ),
                    )
                  : (isToday
                      ? BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.chipIndigoBg,
                          border: Border.all(color: AppTheme.brandPrimary, width: 1.6),
                        )
                      : null),
              child: isStudied
                  ? const Center(
                      child: Icon(
                        Icons.local_fire_department_rounded,
                        size: 17,
                        color: AppTheme.brandAccent,
                      ),
                    )
                  : Center(
                      child: Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                          color: isToday ? AppTheme.brandPrimary : AppTheme.brandTextPrimary,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      );
    }

    // Pad trailing empty days so every row has exactly 7 cells
    while (dayWidgets.length % 7 != 0) {
      dayWidgets.add(const SizedBox(width: 28, height: 28));
    }

    // Grid row layout: exactly 7 Expanded cells per row
    final List<Widget> rows = [];
    for (int i = 0; i < dayWidgets.length; i += 7) {
      final subList = dayWidgets.sublist(i, i + 7);
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Row(
            children: subList.map((w) => Expanded(child: w)).toList(),
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  // 7. Navigation Action Item
  Widget _buildMenuActionItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.brandTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.brandTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppTheme.brandTextMuted, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
