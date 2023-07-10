import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/auth/infrastructure/errors/failure.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_provider.dart';

final firebaseLoginProvider =
    StateNotifierProvider<LoginNotifier, UserCredential?>(
  (ref) => LoginNotifier(
    getCredential: ref.watch(firebaseRepositoryProvider).login,
  ),
);

typedef GetCredential = Future<Either<Failure, UserCredential>> Function();

class LoginNotifier extends StateNotifier<UserCredential?> {
  final GetCredential getCredential;
  LoginNotifier({required this.getCredential}) : super(null);

  Future<void> login() async {
    final failureOrCredential = await getCredential();
    failureOrCredential.fold(
      (failure) => null,
      (credential) => state = credential,
    );
  }
  
}
