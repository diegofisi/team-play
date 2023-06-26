import 'package:dartz/dartz.dart';
import 'package:team_play/feature/auth/domain/datasources/auth_datasource_api.dart';
import 'package:team_play/feature/auth/domain/entities/user.dart';
import 'package:team_play/feature/auth/domain/repositories/auth_datasource_api.dart';
import 'package:team_play/feature/auth/infrastructure/errors/failure.dart';

class AuthRepositoryApiImpl extends AuthDataRepositoryApi{
  final AuthDataSourceApi authDataSourceApi;
  AuthRepositoryApiImpl(this.authDataSourceApi);

  @override
  Future<Either<Failure, UserEntity>> getUserAPI() {
    return authDataSourceApi.getUserAPI();
  }
  
  @override
  Future<Either<Failure, bool>> isRegisterUser() {
    return authDataSourceApi.isRegisterUser();
  }

}