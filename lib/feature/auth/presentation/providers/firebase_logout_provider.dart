import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/auth/infrastructure/errors/failure.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_provider.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_uid_provider.dart';

final firebaseLogoutProvider = StateNotifierProvider<LogoutNotifier, bool>(
  (ref) => LogoutNotifier(
    logoutFuncion: ref.watch(firebaseRepositoryProvider).logout,
    uidNotifier: ref.watch(firebaseUIDProvider.notifier),
  ),
);

typedef LogoutType = Future<Either<Failure, bool>> Function();

class LogoutNotifier extends StateNotifier<bool> {
  final LogoutType logoutFuncion;
  final UidNotifier uidNotifier;
  LogoutNotifier({required this.logoutFuncion, required this.uidNotifier})
      : super(false);

  Future<bool> logout() async {
    final failureOrLogout = await logoutFuncion();
    bool logoutStatus = failureOrLogout.fold(
      (failure) => false,
      (logout) => logout,
    );
    if (logoutStatus) uidNotifier.resetUid();
    return logoutStatus;
  }

  void setLogoutStatus(bool status) {
    state = status;
  }
}
