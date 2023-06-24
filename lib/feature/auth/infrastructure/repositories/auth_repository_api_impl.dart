import 'package:dartz/dartz.dart';
import 'package:team_play/config/helpers/failure.dart';
import 'package:team_play/feature/auth/domain/datasources/auth_datasource_api.dart';
import 'package:team_play/feature/auth/domain/entities/user.dart';
import 'package:team_play/feature/auth/domain/repositories/auth_datasource_api.dart';

class AuthRepositoryApiImpl extends AuthDataRepositoryApi{
  final AuthDataSourceApi authDataSourceApi;

  AuthRepositoryApiImpl(this.authDataSourceApi);

  @override
  Future<Either<Failure, UserEntity>> getUserAPI() {
    // TODO: implement getUserAPI
    throw UnimplementedError();
  }

}