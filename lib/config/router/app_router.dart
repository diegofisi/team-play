import 'package:go_router/go_router.dart';
import 'package:team_play/feature/auth/presentation/screens/initial_screen.dart';
import 'package:team_play/feature/auth/presentation/screens/login_screen.dart';
import 'package:team_play/feature/auth/presentation/screens/register_screen.dart';
import 'package:team_play/feature/home/screens/chat_screen.dart';
import 'package:team_play/feature/home/screens/chats_screen.dart';
import 'package:team_play/feature/home/screens/error_screen.dart';
import 'package:team_play/feature/home/screens/game_registration_screen.dart';
import 'package:team_play/feature/home/screens/game_screen.dart';
import 'package:team_play/feature/home/screens/home_screen.dart';
import 'package:team_play/feature/home/screens/profile_screen.dart';
import 'package:team_play/feature/home/screens/tournament_registration.dart';

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
      path: '/profile/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        if (id == null || id.isEmpty) {
          return const LoginScreen();
        }
        return ProfileScreen(id: id);
      },
    ),
    GoRoute(
      path: '/game/:gameId',
      builder: (context, state) {
        final gameId = state.pathParameters['gameId'];
        return GameScreen(gameId!);
      },
    ),
    GoRoute(
      path: '/tournament_registration',
      builder: (context, state) {
        return const TournamentRegistration();
      },
    ),
    GoRoute(
      path: '/chats/:uid',
      builder: (context, state) {
        final uid = state.pathParameters['uid'];
        if (uid == null || uid.isEmpty) {
          return const LoginScreen();
        }
        return ChatsScreen(uid: uid);
      },
    ),
    GoRoute(
      path: '/chat/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        if (id == null || id.isEmpty) {
          return const ErrorScreen();
        }
        return ChatScreen(id: id);
      },
    ),
  ],
);
