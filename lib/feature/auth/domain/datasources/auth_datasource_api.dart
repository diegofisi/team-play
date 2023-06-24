import 'package:dartz/dartz.dart';
import 'package:team_play/config/helpers/failure.dart';
import 'package:team_play/feature/auth/domain/entities/user.dart';

abstract class AuthDataSourceApi {
  Future<Either<Failure, UserEntity>> getUserAPI();
}
