import 'package:go_router/go_router.dart';
import 'package:team_play/feature/auth/presentation/screens/initial_screen.dart';
import 'package:team_play/feature/auth/presentation/screens/login_screen.dart';
import 'package:team_play/feature/auth/presentation/screens/register_screen.dart';
import 'package:team_play/feature/auth/presentation/screens/token_print.dart';
import 'package:team_play/feature/home/screens/game_registration_screen.dart';
import 'package:team_play/feature/home/screens/game_screen.dart';
import 'package:team_play/feature/home/screens/home_screen.dart';
import 'package:team_play/feature/home/screens/profile_screen.dart';

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
        }
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/game_registration',
      builder: (context, state) => const GameRegistration(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/game',
      builder: (context, state) => const GameScreen(),
    ),
  ],
);
