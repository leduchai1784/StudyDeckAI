import 'package:shared_preferences/shared_preferences.dart';

class SurveyService {
  static final SurveyService _instance = SurveyService._internal();
  factory SurveyService() => _instance;
  SurveyService._internal() {
    loadSurveyData();
  }

  static const String _goalTitleKey = 'studydeck_survey_goal_title_v1';
  static const String _goalIconKey = 'studydeck_survey_goal_icon_v1';
  static const String _levelTitleKey = 'studydeck_survey_level_title_v1';
  static const String _levelIconKey = 'studydeck_survey_level_icon_v1';
  static const String _timeTitleKey = 'studydeck_survey_time_title_v1';
  static const String _timeIconKey = 'studydeck_survey_time_icon_v1';
  static const String _referralTitleKey = 'studydeck_survey_referral_title_v1';
  static const String _referralIconKey = 'studydeck_survey_referral_icon_v1';

  String selectedGoalTitle = 'Du lịch & Khám phá';
  String selectedGoalIcon = '🎯';

  String selectedLevelTitle = 'Mới bắt đầu hoàn toàn';
  String selectedLevelIcon = '💡';

  String selectedTimeTitle = '15 phút/ngày';
  String selectedTimeIcon = '⏱️';

  String selectedReferralTitle = 'TikTok';
  String selectedReferralIcon = '📱';

  bool _isLoaded = false;

  Future<void> loadSurveyData() async {
    if (_isLoaded) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      selectedGoalTitle = prefs.getString(_goalTitleKey) ?? selectedGoalTitle;
      selectedGoalIcon = prefs.getString(_goalIconKey) ?? selectedGoalIcon;

      selectedLevelTitle = prefs.getString(_levelTitleKey) ?? selectedLevelTitle;
      selectedLevelIcon = prefs.getString(_levelIconKey) ?? selectedLevelIcon;

      selectedTimeTitle = prefs.getString(_timeTitleKey) ?? selectedTimeTitle;
      selectedTimeIcon = prefs.getString(_timeIconKey) ?? selectedTimeIcon;

      selectedReferralTitle = prefs.getString(_referralTitleKey) ?? selectedReferralTitle;
      selectedReferralIcon = prefs.getString(_referralIconKey) ?? selectedReferralIcon;
      _isLoaded = true;
    } catch (_) {}
  }

  Future<void> setGoal(String title, String icon) async {
    selectedGoalTitle = title;
    selectedGoalIcon = icon;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_goalTitleKey, title);
    await prefs.setString(_goalIconKey, icon);
  }

  Future<void> setLevel(String title, String icon) async {
    selectedLevelTitle = title;
    selectedLevelIcon = icon;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_levelTitleKey, title);
    await prefs.setString(_levelIconKey, icon);
  }

  Future<void> setTime(String title, String icon) async {
    selectedTimeTitle = title;
    selectedTimeIcon = icon;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_timeTitleKey, title);
    await prefs.setString(_timeIconKey, icon);
  }

  Future<void> setReferral(String title, String icon) async {
    selectedReferralTitle = title;
    selectedReferralIcon = icon;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_referralTitleKey, title);
    await prefs.setString(_referralIconKey, icon);
  }

  /// Tính toán số bài học lộ trình cần hoàn thành mỗi ngày dựa trên thời gian khảo sát:
  /// - 5 phút/ngày  -> 1 bài
  /// - 10 phút/ngày -> 1 bài
  /// - 15 phút/ngày -> 2 bài
  /// - 30 phút/ngày -> 3 bài
  int get dailyLessonTarget {
    final lower = selectedTimeTitle.toLowerCase();
    if (lower.contains('5')) return 1;
    if (lower.contains('10')) return 1;
    if (lower.contains('15')) return 2;
    if (lower.contains('30')) return 3;
    return 2; // Default 15p: 2 bài
  }

  /// Chuỗi thời gian rút gọn (ví dụ: '15 phút')
  String get studyTimeLabel {
    return selectedTimeTitle.replaceAll('/ngày', '').trim();
  }
}
