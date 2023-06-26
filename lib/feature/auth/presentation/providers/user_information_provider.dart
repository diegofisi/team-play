import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/auth/domain/entities/user.dart';
import 'package:team_play/feature/auth/infrastructure/errors/failure.dart';
import 'package:team_play/feature/auth/presentation/providers/user_repository_provider.dart';

final userRepositoryProvider = StateNotifierProvider<UserNotifier, UserEntity?>(
  (ref) => UserNotifier(getUser: ref.watch(authRepositoryProvider).getUserAPI),
);

typedef GetUser = Future<Either<Failure, UserEntity>> Function();

class UserNotifier extends StateNotifier<UserEntity?> {
  final GetUser getUser;

  UserNotifier({required this.getUser}) : super(null);

  Future<UserEntity?> retrieveUser() async {
    final failureOrUser = await getUser();
    return failureOrUser.fold(
      (failure) => null,
      (user) => user,
    );
  }

  void setUser(UserEntity? user) {
    state = user;
  }
}
