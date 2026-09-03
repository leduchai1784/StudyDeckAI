import 'package:go_router/go_router.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/auth/login/screens/login_screen.dart';
import '../../features/auth/register/screens/register_screen.dart';
import '../../features/placement_test/screens/survey_goal_screen.dart';
import '../../features/placement_test/screens/survey_current_level_screen.dart';
import '../../features/placement_test/screens/survey_time_screen.dart';
import '../../features/placement_test/screens/survey_starting_point_screen.dart';
import '../../features/placement_test/screens/ai_assessment_screen.dart';
import '../../features/learning/screens/course_list_screen.dart';
import '../../features/flashcard/screens/deck_list_screen.dart';
import '../../features/flashcard/screens/flashcard_review_screen.dart';
import '../../features/flashcard/screens/create_flashcard_screen.dart';
import '../../features/ai_tutor/screens/studydeck_intelligence_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/documents/screens/document_list_screen.dart';
import '../../shared/layouts/mobile_scaffold.dart';

final List<RouteBase> userRoutes = [
  // 1. Start App: Onboarding (Image 1)
  GoRoute(
    path: '/onboarding',
    builder: (context, state) => const OnboardingScreen(),
  ),

  // 2. Step 1/4: Goal Survey (Image 2)
  GoRoute(
    path: '/survey-goal',
    builder: (context, state) => const SurveyGoalScreen(),
  ),

  // 3. Step 2/4: Level Survey (Image 3)
  GoRoute(
    path: '/survey-level',
    builder: (context, state) => const SurveyCurrentLevelScreen(),
  ),

  // 4. Step 3/4: Time Commitment Survey (Image 4)
  GoRoute(
    path: '/survey-time',
    builder: (context, state) => const SurveyTimeScreen(),
  ),

  // 5. Step 4/4: Starting Point / Skill Test (Image 5)
  GoRoute(
    path: '/survey-start',
    builder: (context, state) => const SurveyStartingPointScreen(),
  ),

  // 6. AI Assessment Result
  GoRoute(
    path: '/ai-assessment',
    builder: (context, state) => const AiAssessmentScreen(),
  ),

  // 7. Login / Register
  GoRoute(
    path: '/login',
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: '/register',
    builder: (context, state) => const RegisterScreen(),
  ),

  // 8. Main App (5 Bottom Navigation Tabs)
  GoRoute(
    path: '/',
    builder: (context, state) => const MobileScaffold(child: HomeScreen()),
  ),
  GoRoute(
    path: '/learning',
    builder: (context, state) => const MobileScaffold(child: CourseListScreen()),
  ),
  GoRoute(
    path: '/flashcards',
    builder: (context, state) => const MobileScaffold(child: DeckListScreen()),
  ),
  GoRoute(
    path: '/ai-tutor',
    builder: (context, state) => const MobileScaffold(child: StudyDeckIntelligenceScreen()),
  ),
  GoRoute(
    path: '/profile',
    builder: (context, state) => const MobileScaffold(child: ProfileScreen()),
  ),

  // Sub-screens & Details
  GoRoute(
    path: '/flashcard-review',
    builder: (context, state) => const FlashcardReviewScreen(),
  ),
  GoRoute(
    path: '/create-flashcard',
    builder: (context, state) => const CreateFlashcardScreen(),
  ),
  GoRoute(
    path: '/documents',
    builder: (context, state) => const MobileScaffold(child: DocumentListScreen()),
  ),
];
