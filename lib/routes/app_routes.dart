import 'package:go_router/go_router.dart';

import '../features/home/screens/home_screen.dart';
import '../features/splash/screens/splash_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const scan = '/scan';
  static const lifestyle = '/lifestyle';
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
  ],
);