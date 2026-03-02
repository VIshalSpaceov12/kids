import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/providers/app_state_provider.dart';
import 'features/onboarding/screens/class_select_screen.dart';
import 'features/onboarding/screens/avatar_select_screen.dart';
import 'features/home/screens/world_map_screen.dart';
import 'features/number_land/screens/number_land_screen.dart';
import 'features/number_land/screens/number_learning_screen.dart';
import 'features/number_land/screens/count_objects_screen.dart';
import 'features/number_land/screens/missing_number_screen.dart';
import 'features/abc_forest/screens/abc_forest_screen.dart';
import 'features/abc_forest/screens/letter_learning_screen.dart';
import 'features/abc_forest/screens/letter_tracing_screen.dart';
import 'features/gujarati_jungle/screens/gujarati_jungle_screen.dart';
import 'features/gujarati_jungle/screens/gujarati_learning_screen.dart';
import 'features/gujarati_jungle/screens/gujarati_tracing_screen.dart';
import 'features/gujarati_jungle/screens/match_akshar_screen.dart';
import 'features/maths_kingdom/screens/maths_kingdom_screen.dart';
import 'features/maths_kingdom/screens/addition_screen.dart';
import 'features/maths_kingdom/screens/subtraction_screen.dart';
import 'features/maths_kingdom/screens/multiplication_screen.dart';
import 'features/maths_kingdom/screens/division_screen.dart';
import 'features/rhymes/screens/rhymes_screen.dart';
import 'features/animals_birds/screens/animals_birds_screen.dart';
import 'features/animals_birds/screens/animal_learning_screen.dart';
import 'features/animals_birds/screens/animal_identify_screen.dart';
import 'features/parent/screens/parent_login_screen.dart';
import 'features/parent/screens/parent_dashboard_screen.dart';

class ChhotuGeniusApp extends StatefulWidget {
  const ChhotuGeniusApp({super.key});

  @override
  State<ChhotuGeniusApp> createState() => _ChhotuGeniusAppState();
}

class _ChhotuGeniusAppState extends State<ChhotuGeniusApp> {
  GoRouter? _router;

  GoRouter _getRouter(AppStateProvider appState) {
    if (_router != null) return _router!;

    final String initialLocation;
    if (!appState.isLoggedIn) {
      initialLocation = '/auth';
    } else if (!appState.isOnboarded) {
      initialLocation = '/onboarding/class';
    } else {
      initialLocation = '/home';
    }

    _router = GoRouter(
      initialLocation: initialLocation,
      refreshListenable: appState,
      redirect: (context, state) {
        final isLoggedIn = appState.isLoggedIn;
        final isOnboarded = appState.isOnboarded;
        final location = state.matchedLocation;
        final isAuthRoute = location == '/auth';
        final isOnboardingRoute = location.startsWith('/onboarding');

        // Not logged in → force /auth
        if (!isLoggedIn) {
          return isAuthRoute ? null : '/auth';
        }

        // Logged in but not onboarded → allow onboarding routes only
        if (!isOnboarded) {
          if (isOnboardingRoute) return null;
          if (isAuthRoute) return '/onboarding/class';
          return '/onboarding/class';
        }

        // Logged in & onboarded → block /auth, allow everything else
        if (isAuthRoute) return '/home';
        return null;
      },
      routes: [
        GoRoute(
          path: '/auth',
          builder: (context, state) =>
              const ParentLoginScreen(isInitialAuth: true),
        ),
        GoRoute(
          path: '/onboarding/class',
          builder: (context, state) => const ClassSelectScreen(),
        ),
        GoRoute(
          path: '/onboarding/avatar',
          builder: (context, state) => const AvatarSelectScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const WorldMapScreen(),
        ),
        GoRoute(
          path: '/number-land',
          builder: (context, state) => const NumberLandScreen(),
        ),
        GoRoute(
          path: '/number-land/learn',
          builder: (context, state) => const NumberLearningScreen(),
        ),
        GoRoute(
          path: '/number-land/count',
          builder: (context, state) => const CountObjectsScreen(),
        ),
        GoRoute(
          path: '/number-land/missing',
          builder: (context, state) => const MissingNumberScreen(),
        ),
        GoRoute(
          path: '/abc-forest',
          builder: (context, state) => const AbcForestScreen(),
        ),
        GoRoute(
          path: '/abc-forest/learn',
          builder: (context, state) => const LetterLearningScreen(),
        ),
        GoRoute(
          path: '/abc-forest/tracing',
          builder: (context, state) => const LetterTracingScreen(),
        ),
        GoRoute(
          path: '/gujarati-jungle',
          builder: (context, state) => const GujaratiJungleScreen(),
        ),
        GoRoute(
          path: '/gujarati-jungle/learn',
          builder: (context, state) => const GujaratiLearningScreen(),
        ),
        GoRoute(
          path: '/gujarati-jungle/tracing',
          builder: (context, state) => const GujaratiTracingScreen(),
        ),
        GoRoute(
          path: '/gujarati-jungle/match',
          builder: (context, state) => const MatchAksharScreen(),
        ),
        GoRoute(
          path: '/maths-kingdom',
          builder: (context, state) => const MathsKingdomScreen(),
        ),
        GoRoute(
          path: '/maths-kingdom/addition',
          builder: (context, state) => const AdditionScreen(),
        ),
        GoRoute(
          path: '/maths-kingdom/subtraction',
          builder: (context, state) => const SubtractionScreen(),
        ),
        GoRoute(
          path: '/maths-kingdom/multiplication',
          builder: (context, state) => const MultiplicationScreen(),
        ),
        GoRoute(
          path: '/maths-kingdom/division',
          builder: (context, state) => const DivisionScreen(),
        ),
        GoRoute(
          path: '/rhymes',
          builder: (context, state) => const RhymesScreen(),
        ),
        GoRoute(
          path: '/animals-birds',
          builder: (context, state) => const AnimalsBirdsScreen(),
        ),
        GoRoute(
          path: '/animals-birds/learn',
          builder: (context, state) => const AnimalLearningScreen(),
        ),
        GoRoute(
          path: '/animals-birds/identify',
          builder: (context, state) => const AnimalIdentifyScreen(),
        ),
        GoRoute(
          path: '/parent/login',
          builder: (context, state) =>
              const ParentLoginScreen(isInitialAuth: false),
        ),
        GoRoute(
          path: '/parent/dashboard',
          builder: (context, state) => const ParentDashboardScreen(),
        ),
      ],
    );

    return _router!;
  }

  @override
  Widget build(BuildContext context) {
    // Use read (not watch) so this widget doesn't rebuild on every state change.
    // GoRouter's refreshListenable handles re-evaluating redirects.
    final appState = context.read<AppStateProvider>();
    final router = _getRouter(appState);

    return MaterialApp.router(
      title: 'Chhotu Genius',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
