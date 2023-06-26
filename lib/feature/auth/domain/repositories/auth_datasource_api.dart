import 'package:dartz/dartz.dart';
import 'package:team_play/feature/auth/domain/entities/user.dart';
import 'package:team_play/feature/auth/infrastructure/errors/failure.dart';
import 'package:team_play/feature/auth/infrastructure/models/user_response.dart';

abstract class AuthDataRepositoryApi {
  Future<Either<Failure, UserEntity>> getUserAPI();
  Future<Either<Failure, bool>> isRegisterUser();
  Future<Either<Failure, UserResponse>> createUserAPI();
  Future<Either<Failure, UserResponse>> editUserAPI();
}
