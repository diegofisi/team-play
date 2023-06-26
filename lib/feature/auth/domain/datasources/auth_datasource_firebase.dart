import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:team_play/feature/auth/infrastructure/errors/failure.dart';

abstract class AuthDataSourceFirebase {
  Future<Either<Failure, UserCredential>> login();
  Future<Either<Failure, String>> getToken();
  String? getUUID();
  Future<Either<Failure, bool>> logout();
}
