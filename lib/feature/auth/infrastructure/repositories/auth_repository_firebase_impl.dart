import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:team_play/feature/auth/domain/datasources/auth_datasource_firebase.dart';
import 'package:team_play/feature/auth/domain/repositories/auth_repository_firebase.dart';
import 'package:team_play/feature/auth/infrastructure/errors/failure.dart';

class AuthRepositoryFirebaseImpl extends AuthDataRepositoryFirebase {
  final AuthDataSourceFirebase datasource;
  AuthRepositoryFirebaseImpl(this.datasource);
  
  @override
  Future<Either<Failure, String>> getToken() {
    return datasource.getToken();
  }
  
  @override
  Either<Failure, String> getUUID() {
    return datasource.getUUID();
  }
  
  @override
  Future<Either<Failure, UserCredential>> login() {
    return datasource.login();
  }
  
  @override
  Future<Either<Failure, bool>> logout() {
    return datasource.logout();
  }  
}
