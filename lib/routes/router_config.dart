import 'package:go_router/go_router.dart';

import '../features/splash/screens/splash_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/face_scan/screens/face_scan_screen.dart';
import '../features/lifestyle/screens/lifestyle_screen.dart';
import '../features/recommendation/screens/recommendation_screen.dart';
import '../features/try_on/screens/try_on_screen.dart';
import '../features/lifestyle_recommendation/screens/lifestyle_recommendation_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const faceScan = '/face-scan';
  static const lifestyle = '/lifestyle';
  static const lifestyleRecommendation = '/lifestyle-recommendation';
  static const recommendation = '/recommendation';
  static const tryOn = '/try-on';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.faceScan,
      builder: (context, state) => const FaceScanScreen(),
    ),
    GoRoute(
      path: AppRoutes.lifestyle,
      builder: (context, state) => const LifestyleScreen(),
    ),
    GoRoute(
      path: AppRoutes.lifestyleRecommendation,
      builder: (context, state) => const LifestyleRecommendationScreen(),
    ),
    GoRoute(
      path: AppRoutes.recommendation,
      builder: (context, state) => const RecommendationScreen(),
    ),
    GoRoute(
      path: AppRoutes.tryOn,
      builder: (context, state) => const TryOnScreen(),
    ),
  ],
);
