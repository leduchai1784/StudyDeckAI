import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/edu_word.dart';
import '../models/user_deck_progress.dart';
import '../models/user_custom_deck.dart';

class FlashcardDueSummary {
  final int unmasteredCount;
  final int periodicDueCount;
  final int totalDueCount;
  final List<EduWord> dueWords;
  final String statusMessage;

  const FlashcardDueSummary({
    required this.unmasteredCount,
    required this.periodicDueCount,
    required this.totalDueCount,
    required this.dueWords,
    required this.statusMessage,
  });
}

class FlashcardProgressService {
  static const String _customWordsKey = 'studydeck_custom_flashcards_v1';
  static const String _customDecksKey = 'studydeck_custom_decks_v1';
  static const String _masteredPrefix = 'studydeck_mastered_words_';
  static const String _favoritesKey = 'studydeck_favorite_word_ids_v1';
  static const String _deckProgressPrefix = 'studydeck_deck_progress_v1_';
  static const String _allTrackedDecksKey = 'studydeck_all_tracked_deck_ids_v1';
  static const String _cardStatsPrefix = 'studydeck_card_stats_v1_';
  static const String _quizResultsPrefix = 'studydeck_quiz_results_v1_';

  // ==========================================
  // 1. DECK PROGRESS PERSISTENCE
  // ==========================================

  Future<UserDeckProgress?> getDeckProgress(String deckId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('$_deckProgressPrefix${deckId.toUpperCase()}');
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return UserDeckProgress.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveDeckProgress(UserDeckProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_deckProgressPrefix${progress.deckId.toUpperCase()}';
    await prefs.setString(key, jsonEncode(progress.toJson()));

    // Add to tracked decks list
    final trackedDecks = prefs.getStringList(_allTrackedDecksKey) ?? [];
    final upperId = progress.deckId.toUpperCase();
    if (!trackedDecks.contains(upperId)) {
      trackedDecks.add(upperId);
      await prefs.setStringList(_allTrackedDecksKey, trackedDecks);
    }
  }

  Future<Map<String, UserDeckProgress>> getAllDeckProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final trackedDecks = prefs.getStringList(_allTrackedDecksKey) ?? [];
    final Map<String, UserDeckProgress> result = {};

    for (final deckId in trackedDecks) {
      final jsonStr = prefs.getString('$_deckProgressPrefix$deckId');
      if (jsonStr != null && jsonStr.isNotEmpty) {
        try {
          final map = jsonDecode(jsonStr) as Map<String, dynamic>;
          result[deckId] = UserDeckProgress.fromJson(map);
        } catch (_) {}
      }
    }
    return result;
  }

  // Update progress as cards are studied in 'study' mode
  Future<void> recordDeckCardStudied(
    String deckId,
    int totalCards,
    int cardIndex,
    bool isMastered,
  ) async {
    final upperId = deckId.toUpperCase();
    var progress = await getDeckProgress(upperId);

    final now = DateTime.now();
    if (progress == null) {
      final completedCards = isMastered ? 1 : 0;
      final double percent = totalCards > 0 ? (completedCards / totalCards) * 100 : 0.0;
      final isFinished = completedCards >= totalCards && totalCards > 0;

      progress = UserDeckProgress(
        deckId: upperId,
        totalCards: totalCards,
        completedCards: completedCards,
        progress: percent,
        status: isFinished ? DeckStatus.completed : DeckStatus.inProgress,
        startedAt: now,
        lastStudiedAt: now,
        completedAt: isFinished ? now : null,
        lastStudiedIndex: cardIndex,
      );
    } else {
      // If already completed, preserve status and 100% progress
      final wasCompleted = progress.status == DeckStatus.completed || progress.progress >= 100.0;

      final newCompletedCards = max(progress.completedCards, cardIndex + 1);
      final isFinished = newCompletedCards >= totalCards && totalCards > 0;
      final double calculatedPercent = totalCards > 0 ? (newCompletedCards / totalCards) * 100 : 0.0;

      progress = progress.copyWith(
        totalCards: totalCards > 0 ? totalCards : progress.totalCards,
        completedCards: wasCompleted ? progress.totalCards : newCompletedCards,
        progress: wasCompleted ? 100.0 : (isFinished ? 100.0 : calculatedPercent),
        status: wasCompleted || isFinished ? DeckStatus.completed : DeckStatus.inProgress,
        lastStudiedAt: now,
        completedAt: (wasCompleted || isFinished) ? (progress.completedAt ?? now) : null,
        lastStudiedIndex: cardIndex,
      );
    }

    await saveDeckProgress(progress);
    await recordTodayStudyActivity();
  }

  // Explicit completion when finishing all cards and tapping "Hoàn tất"
  // GUARANTEED: NEVER RESETS TO 0%
  Future<void> recordDeckCompletion(String deckId, int totalCards) async {
    final upperId = deckId.toUpperCase();
    var progress = await getDeckProgress(upperId);
    final now = DateTime.now();

    if (progress == null) {
      progress = UserDeckProgress(
        deckId: upperId,
        totalCards: totalCards,
        completedCards: totalCards,
        progress: 100.0,
        status: DeckStatus.completed,
        startedAt: now,
        lastStudiedAt: now,
        completedAt: now,
        lastStudiedIndex: max(0, totalCards - 1),
      );
    } else {
      progress = progress.copyWith(
        totalCards: totalCards > 0 ? totalCards : progress.totalCards,
        completedCards: totalCards > 0 ? totalCards : progress.totalCards,
        progress: 100.0,
        status: DeckStatus.completed,
        lastStudiedAt: now,
        completedAt: progress.completedAt ?? now,
        lastStudiedIndex: max(0, totalCards - 1),
      );
    }

    await saveDeckProgress(progress);
    await recordTodayStudyActivity();
  }

  // Increment review count when user completes a review session
  Future<void> incrementDeckReviewCount(String deckId) async {
    final upperId = deckId.toUpperCase();
    final progress = await getDeckProgress(upperId);
    if (progress != null) {
      await saveDeckProgress(
        progress.copyWith(
          reviewCount: progress.reviewCount + 1,
          lastStudiedAt: DateTime.now(),
        ),
      );
      await recordTodayStudyActivity();
    }
  }

  // ==========================================
  // 2. CARD LEARNING STATS & SPACED REPETITION
  // ==========================================

  Future<Map<int, CardLearningStat>> getCardStats(String deckId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_cardStatsPrefix${deckId.toUpperCase()}';
    final jsonStr = prefs.getString(key);
    if (jsonStr == null || jsonStr.isEmpty) return {};

    try {
      final Map<String, dynamic> rawMap = jsonDecode(jsonStr);
      final Map<int, CardLearningStat> result = {};
      rawMap.forEach((k, v) {
        final intId = int.tryParse(k);
        if (intId != null && v is Map<String, dynamic>) {
          result[intId] = CardLearningStat.fromJson(v);
        }
      });
      return result;
    } catch (_) {
      return {};
    }
  }

  Future<void> saveCardStats(String deckId, Map<int, CardLearningStat> stats) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_cardStatsPrefix${deckId.toUpperCase()}';
    final Map<String, dynamic> rawMap = {};
    stats.forEach((k, v) {
      rawMap[k.toString()] = v.toJson();
    });
    await prefs.setString(key, jsonEncode(rawMap));
  }

  Future<void> updateCardAnswer(String deckId, int wordId, bool isMastered) async {
    final stats = await getCardStats(deckId);
    final now = DateTime.now();
    var stat = stats[wordId] ?? CardLearningStat(wordId: wordId, deckId: deckId);

    if (isMastered) {
      final newMasteryLevel = min(3, stat.masteryLevel + 1);
      final daysToAdd = newMasteryLevel == 1 ? 1 : (newMasteryLevel == 2 ? 3 : 7);
      stat = stat.copyWith(
        correctCount: stat.correctCount + 1,
        incorrectCount: 0,
        masteryLevel: newMasteryLevel,
        isMastered: true,
        lastReviewedAt: now,
        nextReviewDue: now.add(Duration(days: daysToAdd)),
      );
    } else {
      stat = stat.copyWith(
        incorrectCount: stat.incorrectCount + 1,
        masteryLevel: 0,
        isMastered: false,
        lastReviewedAt: now,
        nextReviewDue: now, // Due immediately
      );
    }

    stats[wordId] = stat;
    await saveCardStats(deckId, stats);

    // Also update backward-compatible mastered IDs
    await recordWordProgress(deckId, wordId, stat.isMastered);
  }

  /// Cập nhật kết quả thẻ đồng bộ qua tất cả bộ thẻ mà từ này từng xuất hiện
  Future<void> updateCardAnswerGlobal(
    int wordId,
    bool isMastered, {
    String? targetDeckId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final trackedDecks = prefs.getStringList(_allTrackedDecksKey) ?? [];
    const standardLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2', 'PERSONAL'];
    final Set<String> allDeckIds = {
      ...standardLevels,
      ...trackedDecks,
    };
    if (targetDeckId != null && targetDeckId.isNotEmpty) {
      allDeckIds.add(targetDeckId.toUpperCase());
    }

    bool found = false;
    for (final deck in allDeckIds) {
      final stats = await getCardStats(deck);
      if (stats.containsKey(wordId)) {
        await updateCardAnswer(deck, wordId, isMastered);
        found = true;
      }
    }

    if (!found && targetDeckId != null && targetDeckId.isNotEmpty) {
      await updateCardAnswer(targetDeckId, wordId, isMastered);
    }
  }

  // ==========================================
  // 3. SMART REVIEW ALGORITHM
  // ==========================================

  Future<List<EduWord>> getSmartReviewWords(String deckId, List<EduWord> allWords) async {
    if (allWords.isEmpty) return [];
    final stats = await getCardStats(deckId);
    final now = DateTime.now();

    // Group cards into priority tiers
    final List<EduWord> highPriority = []; // High error count & not mastered
    final List<EduWord> mediumPriority = []; // Due for review or low mastery
    final List<EduWord> remaining = []; // Mastered or not yet reviewed

    for (final word in allWords) {
      final stat = stats[word.id];
      if (stat == null) {
        remaining.add(word);
      } else if (stat.incorrectCount > 0 && !stat.isMastered) {
        highPriority.add(word);
      } else if (stat.masteryLevel < 2 || (stat.nextReviewDue != null && stat.nextReviewDue!.isBefore(now))) {
        mediumPriority.add(word);
      } else {
        remaining.add(word);
      }
    }

    // Sort high priority by most incorrect first
    highPriority.sort((a, b) {
      final aErr = stats[a.id]?.incorrectCount ?? 0;
      final bErr = stats[b.id]?.incorrectCount ?? 0;
      return bErr.compareTo(aErr);
    });

    final List<EduWord> result = [];
    result.addAll(highPriority);
    result.addAll(mediumPriority);

    // If result is empty or small (e.g. user mastered everything), include some cards for practice
    if (result.isEmpty) {
      // Pick up to 10 cards with oldest review time or just first 10
      remaining.sort((a, b) {
        final aTime = stats[a.id]?.lastReviewedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = stats[b.id]?.lastReviewedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return aTime.compareTo(bTime);
      });
      result.addAll(remaining.take(min(10, remaining.length)));
    }

    return result;
  }

  Future<int> getSmartReviewWordsCount(String deckId, List<EduWord> allWords) async {
    final list = await getSmartReviewWords(deckId, allWords);
    return list.length;
  }

  // ==========================================
  // 3.1 GLOBAL SM-2 DUE FLASHCARDS SCANNER
  // ==========================================

  Future<FlashcardDueSummary> getGlobalDueFlashcardsSummary({
    Map<String, List<EduWord>>? groupedWords,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final trackedDecks = prefs.getStringList(_allTrackedDecksKey) ?? [];
    const standardLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2', 'PERSONAL'];

    final Set<String> allDeckIds = {
      ...standardLevels,
      ...trackedDecks,
    };

    final now = DateTime.now();
    final Set<int> unmasteredIds = {};
    final Set<int> periodicDueIds = {};

    for (final deckId in allDeckIds) {
      final stats = await getCardStats(deckId);
      for (final stat in stats.values) {
        final bool isDuePeriodically = stat.lastReviewedAt != null &&
            stat.nextReviewDue != null &&
            stat.nextReviewDue!.isBefore(now);

        final bool isDueUnmastered = stat.incorrectCount > 0 &&
            !stat.isMastered &&
            (stat.nextReviewDue == null || stat.nextReviewDue!.isBefore(now));

        if (isDueUnmastered) {
          unmasteredIds.add(stat.wordId);
        } else if (isDuePeriodically) {
          periodicDueIds.add(stat.wordId);
        }
      }
    }

    final int unmasteredCount = unmasteredIds.length;
    final int periodicDueCount = periodicDueIds.length;
    final int totalCount = unmasteredCount + periodicDueCount;

    // Collect matching EduWord objects if groupedWords is available
    final List<EduWord> dueWords = [];
    if (groupedWords != null && groupedWords.isNotEmpty) {
      final allWordsMap = <int, EduWord>{};
      for (final list in groupedWords.values) {
        for (final w in list) {
          allWordsMap[w.id] = w;
        }
      }

      // Prioritize unmastered first, then periodic due
      for (final id in unmasteredIds) {
        if (allWordsMap.containsKey(id)) {
          dueWords.add(allWordsMap[id]!);
        }
      }
      for (final id in periodicDueIds) {
        if (allWordsMap.containsKey(id) && !dueWords.any((w) => w.id == id)) {
          dueWords.add(allWordsMap[id]!);
        }
      }

      // If user has zero recorded due cards but totalCount == 0, provide sample starter cards
      if (dueWords.isEmpty && totalCount == 0) {
        final a1Words = groupedWords['A1'] ?? [];
        if (a1Words.isNotEmpty) {
          dueWords.addAll(a1Words.take(10));
        }
      }
    }

    String statusMsg;
    if (unmasteredCount > 0 && periodicDueCount > 0) {
      statusMsg = 'Gồm $unmasteredCount thẻ chưa nhớ & $periodicDueCount thẻ đến hạn ôn định kỳ theo SM-2.';
    } else if (unmasteredCount > 0) {
      statusMsg = 'Gồm $unmasteredCount thẻ chưa nhớ cần củng cố lại trí nhớ.';
    } else if (periodicDueCount > 0) {
      statusMsg = 'Gồm $periodicDueCount thẻ đến hạn ôn định kỳ theo chu kỳ SM-2.';
    } else {
      statusMsg = 'Trí nhớ đang ở trạng thái tối ưu! Tất cả thẻ đã ôn hoặc chưa có thẻ quên.';
    }

    return FlashcardDueSummary(
      unmasteredCount: unmasteredCount,
      periodicDueCount: periodicDueCount,
      totalDueCount: totalCount,
      dueWords: dueWords,
      statusMessage: statusMsg,
    );
  }

  // ==========================================
  // 4. QUIZ RESULTS PERSISTENCE
  // ==========================================

  Future<List<QuizSession>> getQuizSessions(String deckId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_quizResultsPrefix${deckId.toUpperCase()}';
    final jsonStr = prefs.getString(key);
    if (jsonStr == null || jsonStr.isEmpty) return [];

    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => QuizSession.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> recordQuizResult(QuizSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_quizResultsPrefix${session.deckId.toUpperCase()}';
    final existing = await getQuizSessions(session.deckId);
    existing.insert(0, session);

    // Keep last 20 quiz sessions
    final trimmed = existing.take(20).toList();
    await prefs.setString(key, jsonEncode(trimmed.map((e) => e.toJson()).toList()));
    await recordTodayStudyActivity();
  }

  // ==========================================
  // 5. EXISTING UTILITIES & CUSTOM FLASHCARDS
  // ==========================================

  Future<List<EduWord>> getCustomWords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_customWordsKey);
    if (jsonStr == null || jsonStr.isEmpty) {
      return [
        EduWord(
          id: 9901,
          title: 'StudyDeck',
          viword: 'Bộ thẻ học tập thông minh',
          description: 'An AI-powered smart learning platform',
          videscription: 'Nền tảng học tập thông minh tích hợp trí tuệ nhân tạo',
          transcription: '/ˈstʌdi dek/',
          example: 'I use StudyDeck to master vocabulary every day.',
          level: 'PERSONAL',
        ),
      ];
    }

    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((item) => EduWord.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  // ==========================================
  // 5. USER CUSTOM DECKS MANAGEMENT
  // ==========================================

  Future<List<UserCustomDeck>> getCustomDecks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_customDecksKey);
    if (jsonStr == null || jsonStr.isEmpty) {
      final defaultDeck = UserCustomDeck(
        id: 'default_personal',
        name: 'Bộ từ mặc định',
        description: 'Bộ thẻ từ vựng cá nhân tự thêm',
        colorValue: 0xFF6D28D9,
        createdAt: DateTime.now(),
      );
      await saveCustomDecks([defaultDeck]);
      return [defaultDeck];
    }
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      final decks = list.map((e) => UserCustomDeck.fromJson(e as Map<String, dynamic>)).toList();
      if (decks.isEmpty) {
        final defaultDeck = UserCustomDeck(
          id: 'default_personal',
          name: 'Bộ từ mặc định',
          description: 'Bộ thẻ từ vựng cá nhân tự thêm',
          colorValue: 0xFF6D28D9,
          createdAt: DateTime.now(),
        );
        await saveCustomDecks([defaultDeck]);
        return [defaultDeck];
      }
      return decks;
    } catch (_) {
      return [];
    }
  }

  Future<void> saveCustomDecks(List<UserCustomDeck> decks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(decks.map((e) => e.toJson()).toList());
    await prefs.setString(_customDecksKey, jsonStr);
  }

  Future<UserCustomDeck> createCustomDeck({
    required String name,
    String description = '',
    int colorValue = 0xFF6D28D9,
  }) async {
    final decks = await getCustomDecks();
    final newDeck = UserCustomDeck(
      id: 'deck_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      description: description.trim(),
      colorValue: colorValue,
      createdAt: DateTime.now(),
    );
    decks.insert(0, newDeck);
    await saveCustomDecks(decks);
    return newDeck;
  }

  Future<void> deleteCustomDeck(String id) async {
    final decks = await getCustomDecks();
    decks.removeWhere((d) => d.id == id);
    await saveCustomDecks(decks);
  }

  Future<List<EduWord>> getWordsForCustomDeck(String deckId) async {
    final allCustom = await getCustomWords();
    return allCustom.where((w) => (w.customDeckId ?? 'default_personal') == deckId).toList();
  }

  Future<void> addCustomWord({
    required String title,
    required String viword,
    String? transcription,
    String? description,
    String? videscription,
    String? example,
    String? customDeckId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getCustomWords();

    final newWord = EduWord(
      id: DateTime.now().millisecondsSinceEpoch % 1000000,
      title: title.trim(),
      viword: viword.trim(),
      description: description?.trim() ?? '',
      videscription: videscription?.trim() ?? '',
      transcription: transcription?.trim() ?? '',
      example: example?.trim() ?? '',
      level: 'PERSONAL',
      customDeckId: customDeckId ?? 'default_personal',
    );

    existing.insert(0, newWord);
    final jsonStr = jsonEncode(existing.map((e) => e.toJson()).toList());
    await prefs.setString(_customWordsKey, jsonStr);
  }

  Future<Set<int>> getFavoriteWordIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_favoritesKey);
    if (list == null) return {};
    return list.map((id) => int.tryParse(id) ?? 0).toSet();
  }

  Future<bool> toggleFavoriteWordId(int wordId) async {
    final prefs = await SharedPreferences.getInstance();
    final set = await getFavoriteWordIds();
    final isStarredNow = !set.contains(wordId);
    if (isStarredNow) {
      set.add(wordId);
    } else {
      set.remove(wordId);
    }
    await prefs.setStringList(_favoritesKey, set.map((e) => e.toString()).toList());
    return isStarredNow;
  }

  Future<Set<int>> getMasteredWordIds(String deckKey) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('$_masteredPrefix$deckKey');
    if (list == null) return {};
    return list.map((id) => int.tryParse(id) ?? 0).toSet();
  }

  Future<void> recordWordProgress(String deckKey, int wordId, bool isMastered) async {
    final prefs = await SharedPreferences.getInstance();
    final set = await getMasteredWordIds(deckKey);

    if (isMastered) {
      set.add(wordId);
    } else {
      set.remove(wordId);
    }

    await prefs.setStringList('$_masteredPrefix$deckKey', set.map((id) => id.toString()).toList());
  }

  Future<void> resetDeckProgress(String deckKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_masteredPrefix$deckKey');
    await prefs.remove('$_deckProgressPrefix${deckKey.toUpperCase()}');
  }

  // ==========================================
  // 6. PROFILE & TARGET BAND STATS
  // ==========================================

  static const String _targetBandKey = 'studydeck_target_band_v1';
  static const String _streakDaysKey = 'studydeck_streak_days_v1';
  static const String _activeDatesKey = 'studydeck_active_dates_v1';

  static String _formatDateOnly(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  Future<Set<String>> getActiveStudyDates() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_activeDatesKey) ?? [];
    final set = list.toSet();

    // Populate from deck progress and quiz history so historical real-time data is included
    try {
      final decks = await getAllDeckProgress();
      for (final p in decks.values) {
        if (p.lastStudiedAt != null) {
          set.add(_formatDateOnly(p.lastStudiedAt!));
        }
        if (p.completedAt != null) {
          set.add(_formatDateOnly(p.completedAt!));
        }
      }
    } catch (_) {}

    return set;
  }

  Future<void> recordTodayStudyActivity() async {
    final prefs = await SharedPreferences.getInstance();
    final dates = await getActiveStudyDates();
    final todayStr = _formatDateOnly(DateTime.now());
    dates.add(todayStr);
    await prefs.setStringList(_activeDatesKey, dates.toList());

    final streak = calculateRealTimeStreak(dates);
    await prefs.setInt(_streakDaysKey, streak);
  }

  int calculateRealTimeStreak(Set<String> activeDates) {
    if (activeDates.isEmpty) return 0;
    final now = DateTime.now();
    final todayStr = _formatDateOnly(now);
    final yesterdayStr = _formatDateOnly(now.subtract(const Duration(days: 1)));

    // If neither today nor yesterday has study activity, streak is 0
    if (!activeDates.contains(todayStr) && !activeDates.contains(yesterdayStr)) {
      return 0;
    }

    int streak = 0;
    DateTime checkDate = activeDates.contains(todayStr) ? now : now.subtract(const Duration(days: 1));

    while (activeDates.contains(_formatDateOnly(checkDate))) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return streak;
  }

  Future<double> getTargetBand() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_targetBandKey) ?? 6.5;
  }

  Future<void> setTargetBand(double band) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_targetBandKey, band);
  }

  Future<int> getStreakDays() async {
    final prefs = await SharedPreferences.getInstance();
    final dates = await getActiveStudyDates();
    if (dates.isNotEmpty) {
      final realStreak = calculateRealTimeStreak(dates);
      final storedStreak = prefs.getInt(_streakDaysKey) ?? 1;
      return max(realStreak, storedStreak > 0 ? storedStreak : 1);
    }
    return prefs.getInt(_streakDaysKey) ?? 1;
  }

  Future<Set<int>> getStudiedDaysForMonth(int year, int month) async {
    final dates = await getActiveStudyDates();
    final prefix = '$year-${month.toString().padLeft(2, '0')}-';
    final Set<int> result = {};

    for (final d in dates) {
      if (d.startsWith(prefix)) {
        final dayPart = int.tryParse(d.substring(prefix.length));
        if (dayPart != null) {
          result.add(dayPart);
        }
      }
    }

    // Include today if streak > 0
    final now = DateTime.now();
    if (now.year == year && now.month == month) {
      final streak = await getStreakDays();
      if (streak > 0) {
        result.add(now.day);
      }
    }

    return result;
  }

  Future<int> getTotalMasteredAndCustomWordsCount() async {
    final customWords = await getCustomWords();
    final favIds = await getFavoriteWordIds();
    return customWords.length + favIds.length;
  }

  static const String _learningProgressKey = 'studydeck_overall_learning_progress_v1';

  Future<double> getOverallLearningProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final allProgress = await getAllDeckProgress();
    const standardLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
    double sumProgress = 0.0;
    int trackedCount = 0;

    for (final lvl in standardLevels) {
      final p = allProgress[lvl];
      if (p != null) {
        sumProgress += p.progress.clamp(0.0, 100.0);
        trackedCount++;
      }
    }

    if (trackedCount > 0 && sumProgress > 0) {
      return (sumProgress / standardLevels.length).clamp(0.0, 100.0);
    }

    return prefs.getDouble(_learningProgressKey) ?? 68.0;
  }

  Future<void> setOverallLearningProgress(double progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_learningProgressKey, progress.clamp(0.0, 100.0));
  }
}
