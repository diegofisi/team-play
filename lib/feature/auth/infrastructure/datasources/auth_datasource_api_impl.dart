import 'package:dartz/dartz.dart';
import 'package:team_play/config/helpers/failure.dart';
import 'package:team_play/feature/auth/domain/datasources/auth_datasource_api.dart';
import 'package:team_play/feature/auth/domain/entities/user.dart';

class AuthDatasourceApiImpl extends AuthDataSourceApi {
  
  @override
  Future<Either<Failure, UserEntity>> getUserAPI() {
    // TODO: implement getUserAPI
    throw UnimplementedError();
  }
}
