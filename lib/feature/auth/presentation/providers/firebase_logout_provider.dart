import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_provider.dart';

final firebaseLogoutProvider = StateNotifierProvider<LogoutNotifier, void>(
    (ref) =>
        LogoutNotifier(logout: ref.watch(firebaseRepositoryProvider).logout));

typedef Logout = Future<void> Function();

class LogoutNotifier extends StateNotifier<void> {
  final Logout logout;
  LogoutNotifier({required this.logout}) : super(null);

  Future<void> logoutUser() async {
    await logout();
  }
}
