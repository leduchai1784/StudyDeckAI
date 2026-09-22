import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/auth/login/screens/login_screen.dart';
import '../../features/auth/register/screens/register_screen.dart';
import '../../features/placement_test/screens/survey_goal_screen.dart';
import '../../features/placement_test/screens/survey_current_level_screen.dart';
import '../../features/placement_test/screens/survey_time_screen.dart';
import '../../features/placement_test/screens/survey_referral_screen.dart';
import '../../features/placement_test/screens/survey_summary_screen.dart';
import '../../features/placement_test/screens/survey_starting_point_screen.dart';
import '../../features/learning/screens/course_list_screen.dart';
import '../../features/flashcard/screens/deck_list_screen.dart';
import '../../features/flashcard/screens/flashcard_review_screen.dart';
import '../../features/flashcard/screens/create_flashcard_screen.dart';
import '../../features/flashcard/screens/deck_detail_screen.dart';
import '../../features/flashcard/screens/deck_quiz_screen.dart';
import '../../features/flashcard/screens/personal_decks_screen.dart';
import '../../models/edu_word.dart';
import '../../features/ai_tutor/screens/ai_tutor_chat_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/settings_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/change_password_screen.dart';
import '../../features/profile/screens/update_cccd_screen.dart';
import '../../features/documents/screens/document_list_screen.dart';
import '../../features/skills/screens/skill_detail_screen.dart';
import '../../features/grammar/screens/grammar_lesson_detail_screen.dart';
import '../../features/reading/screens/reading_hub_screen.dart';
import '../../features/reading/screens/reading_practice_screen.dart';
import '../../features/reading/screens/reading_result_screen.dart';
import '../../features/reading/models/reading_test_model.dart';
import '../../features/reading/models/reading_result_model.dart';
import '../../features/skills/screens/dictation_library_screen.dart';
import '../../features/skills/screens/listening_dictation_screen.dart';
import '../../features/skills/models/dictation_model.dart';
import '../../features/speaking/screens/speaking_hub_screen.dart';
import '../../features/speaking/screens/speaking_forecast_screen.dart';
import '../../features/speaking/screens/speaking_roulette_screen.dart';
import '../../features/speaking/screens/speaking_practice_screen.dart';
import '../../features/speaking/models/speaking_model.dart';
import '../../features/writing/screens/writing_hub_screen.dart';
import '../../features/writing/screens/writing_tests_list_screen.dart';
import '../../features/writing/screens/writing_practice_screen.dart';
import '../../features/writing/screens/writing_translation_screen.dart';
import '../../features/writing/models/writing_model.dart';
import '../../shared/layouts/mobile_scaffold.dart';

final List<RouteBase> userRoutes = [
  // 1. App Starting Screen: Onboarding Screen
  GoRoute(
    path: '/onboarding',
    builder: (context, state) => const OnboardingScreen(),
  ),

  // 2. Step 1/4: Goal Survey
  GoRoute(
    path: '/survey-goal',
    builder: (context, state) => const SurveyGoalScreen(),
  ),

  // 3. Step 2/4: Level Survey
  GoRoute(
    path: '/survey-level',
    builder: (context, state) => const SurveyCurrentLevelScreen(),
  ),

  // 4. Step 3/4: Time Commitment Survey
  GoRoute(
    path: '/survey-time',
    builder: (context, state) => const SurveyTimeScreen(),
  ),

  // 5. Step 4/4: Referral Channel Survey (Bạn biết đến chúng mình từ đâu?)
  GoRoute(
    path: '/survey-referral',
    builder: (context, state) => const SurveyReferralScreen(),
  ),

  // 6. Post-Survey Summary & Thank You Screen (Cảm ơn bạn! 🎉)
  GoRoute(
    path: '/survey-summary',
    builder: (context, state) => const SurveySummaryScreen(),
  ),

  // 7. Starting Point / Skill Test (Chọn điểm khởi đầu của bạn)
  GoRoute(
    path: '/survey-start',
    builder: (context, state) => const SurveyStartingPointScreen(),
  ),

  // 8. Login / Register
  GoRoute(
    path: '/login',
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: '/register',
    builder: (context, state) => const RegisterScreen(),
  ),

  // 9. Main App Layout - Persistent Shell & Stateful IndexedStack
  StatefulShellRoute.indexedStack(
    builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
      return MobileScaffold(navigationShell: navigationShell);
    },
    branches: <StatefulShellBranch>[
      // Branch 0: Home Tab (Index 0)
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
        ],
      ),

      // Branch 1: Learning Tab (Index 1)
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(
            path: '/learning',
            builder: (context, state) => const CourseListScreen(),
          ),
        ],
      ),

      // Branch 2: AI Tutor Tab - CENTER TAB (Index 2)
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(
            path: '/ai-tutor',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              return AiTutorChatScreen(
                initialPrompt: extra?['initialPrompt'] as String?,
                initialMode: extra?['initialMode'] as String?,
              );
            },
          ),
        ],
      ),

      // Branch 3: Flashcards Tab (Index 3)
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(
            path: '/flashcards',
            builder: (context, state) => const DeckListScreen(),
          ),
        ],
      ),

      // Branch 4: Profile Tab (Index 4)
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  ),

  // Profile extensions
  GoRoute(
    path: '/settings',
    builder: (context, state) => const SettingsScreen(),
  ),
  GoRoute(
    path: '/edit-profile',
    builder: (context, state) => const EditProfileScreen(),
  ),
  GoRoute(
    path: '/change-password',
    builder: (context, state) => const ChangePasswordScreen(),
  ),
  GoRoute(
    path: '/update-cccd',
    builder: (context, state) => const UpdateCccdScreen(),
  ),

  // Sub-screens & Details
  GoRoute(
    path: '/flashcard-review',
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      return FlashcardReviewScreen(
        level: extra?['level'] as String? ?? 'A1',
        levelTitle: extra?['levelTitle'] as String? ?? 'Bộ Thẻ Cấp A1',
        mode: extra?['mode'] as String? ?? 'study',
        customWords: extra?['customWords'] as List<EduWord>?,
        startIndex: extra?['startIndex'] as int? ?? 0,
      );
    },
  ),
  GoRoute(
    path: '/deck-detail',
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      return DeckDetailScreen(
        deckId: extra?['deckId'] as String? ?? 'A1',
        deckTitle: extra?['deckTitle'] as String? ?? 'Bộ Thẻ Cấp A1',
      );
    },
  ),
  GoRoute(
    path: '/deck-quiz',
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      return DeckQuizScreen(
        deckId: extra?['deckId'] as String? ?? 'A1',
        deckTitle: extra?['deckTitle'] as String? ?? 'Bộ Thẻ Cấp A1',
      );
    },
  ),
  GoRoute(
    path: '/create-flashcard',
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      return CreateFlashcardScreen(
        preselectedDeckId: extra?['preselectedDeckId'] as String?,
      );
    },
  ),
  GoRoute(
    path: '/personal-decks',
    builder: (context, state) => const PersonalDecksScreen(),
  ),
  GoRoute(
    path: '/documents',
    builder: (context, state) => const DocumentListScreen(),
  ),

  // Skill Practice Screens (Listening, Reading, Speaking, Writing)
  GoRoute(
    path: '/skill/:skillType',
    builder: (context, state) {
      final skillType = state.pathParameters['skillType'] ?? 'listening';
      return SkillDetailScreen(skillType: skillType);
    },
  ),

  // Grammar IELTS Practice (Redirects to unified Course & Roadmap screen)
  GoRoute(
    path: '/grammar',
    redirect: (context, state) => '/learning',
  ),
  GoRoute(
    path: '/grammar/lesson',
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      final lessonId = extra?['lessonId'] as String? ?? 'grm_word_forms';
      return GrammarLessonDetailScreen(lessonId: lessonId);
    },
  ),

  // AI Tutor Direct Chat Screen (Powered by Gemini)
  GoRoute(
    path: '/ai-tutor/chat',
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      return AiTutorChatScreen(
        initialPrompt: extra?['initialPrompt'] as String?,
        initialMode: extra?['initialMode'] as String?,
      );
    },
  ),

  // IELTS Reading Module Routes
  GoRoute(
    path: '/reading',
    builder: (context, state) => const ReadingHubScreen(),
  ),
  GoRoute(
    path: '/reading/practice',
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      final test = extra?['test'] as ReadingTest;
      return ReadingPracticeScreen(test: test);
    },
  ),
  GoRoute(
    path: '/reading/result',
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      final test = extra?['test'] as ReadingTest;
      final result = extra?['result'] as ReadingTestResult;
      return ReadingResultScreen(test: test, result: result);
    },
  ),

  // Dictation Module Routes
  GoRoute(
    path: '/dictation',
    builder: (context, state) => const DictationLibraryScreen(),
  ),
  GoRoute(
    path: '/dictation/practice',
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      final exercise = extra?['exercise'] as DictationExercise?;
      return ListeningDictationScreen(exercise: exercise);
    },
  ),

  // Speaking Module Routes
  GoRoute(
    path: '/speaking',
    builder: (context, state) => const SpeakingHubScreen(),
  ),
  GoRoute(
    path: '/speaking/forecast',
    builder: (context, state) => const SpeakingForecastScreen(),
  ),
  GoRoute(
    path: '/speaking/roulette',
    builder: (context, state) => const SpeakingRouletteScreen(),
  ),
  GoRoute(
    path: '/speaking/practice',
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      final topic = extra?['topic'] as SpeakingTopic;
      final initialIndex = extra?['initialIndex'] as int? ?? 0;
      return SpeakingPracticeScreen(
        topic: topic,
        initialQuestionIndex: initialIndex,
      );
    },
  ),

  // Writing Module Routes
  GoRoute(
    path: '/writing',
    builder: (context, state) => const WritingHubScreen(),
  ),
  GoRoute(
    path: '/writing/tests',
    builder: (context, state) => const WritingTestsListScreen(),
  ),
  GoRoute(
    path: '/writing/practice',
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      final prompt = extra?['prompt'] as WritingPrompt;
      return WritingPracticeScreen(prompt: prompt);
    },
  ),
  GoRoute(
    path: '/writing/translation',
    builder: (context, state) => const WritingTranslationScreen(),
  ),
];
