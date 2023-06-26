import 'package:go_router/go_router.dart';
import 'package:team_play/feature/auth/presentation/screens/initial_screen.dart';
import 'package:team_play/feature/auth/presentation/screens/login_screen.dart';
import 'package:team_play/feature/auth/presentation/screens/register_screen.dart';
import 'package:team_play/feature/home/presentation/screens/home_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const InitialScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home/:uid',
      builder: (context, state) {
        final uid = state.pathParameters['uid'];
        if (uid == null || uid.isEmpty) {
          return const RegisterScreen();
        } else {
          return const HomeScreen();
        }
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    )
  ],
);
