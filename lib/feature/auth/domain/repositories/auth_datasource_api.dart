import 'package:dartz/dartz.dart';
import 'package:team_play/feature/auth/domain/entities/user.dart';
import 'package:team_play/feature/auth/infrastructure/errors/failure.dart';
import 'package:team_play/feature/auth/infrastructure/models/user_edit.dart';
import 'package:team_play/feature/auth/infrastructure/models/user_request.dart';
import 'package:team_play/feature/auth/infrastructure/models/user_response.dart';

abstract class AuthDataRepositoryApi {
  Future<Either<Failure, UserEntity>> getUserAPI();
  Future<Either<Failure, bool>> isRegisterUser();
  Future<void> createUserAPI(UserRequest userRequest);
  Future<void> editUserAPI(UserEdit userRequest);
  Future<List<UserResponse>> getUsersAPI();
}
