import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/auth/infrastructure/datasources/auth_datasource_api_impl.dart';
import 'package:team_play/feature/auth/infrastructure/errors/failure.dart';
import 'package:team_play/feature/auth/infrastructure/repositories/auth_repository_api_impl.dart';

final userRepositoryProvider = Provider(
  (ref) => AuthRepositoryApiImpl(AuthDatasourceApiImpl()).getUserAPI(),
);

final authRepositoryProvider = Provider(
  (ref) => AuthRepositoryApiImpl(AuthDatasourceApiImpl()),
);

final isUserRegisteredProvider =
    StateNotifierProvider<IsUserRegisteredNotifier, bool>(
  (ref) => IsUserRegisteredNotifier(
      getIsUserRegistered: ref.watch(authRepositoryProvider).isRegisterUser),
);

typedef GetIsUserRegistered = Future<Either<Failure, bool>> Function();

class IsUserRegisteredNotifier extends StateNotifier<bool> {
  final GetIsUserRegistered getIsUserRegistered;

  IsUserRegisteredNotifier({required this.getIsUserRegistered}) : super(false);

  Future<bool> checkUserRegistration() async {
    final failureOrIsRegistered = await getIsUserRegistered();
    return failureOrIsRegistered.fold(
      (failure) => false,
      (isRegistered) => isRegistered ,
    );
  }

  void setIsUserRegistered(bool isRegistered) {
    state = isRegistered;
  }
}