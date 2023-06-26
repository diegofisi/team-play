import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:team_play/config/helpers/failure.dart';
import 'package:team_play/feature/auth/domain/datasources/auth_datasource_firebase.dart';
import 'package:team_play/feature/auth/domain/repositories/auth_repository_firebase.dart';

class AuthRepositoryFirebaseImpl extends AuthDataRepositoryFirebase {
  final AuthDataSourceFirebase datasource;

  AuthRepositoryFirebaseImpl(this.datasource);
  
  @override
  Future<String?> getToken() {
    return datasource.getToken();
  }
  
  @override
  String? getUUID() {
    return datasource.getUUID();
  }
  
  @override
  bool isLogin() {
    return datasource.isLogin();
  }
  
  @override
  Future<UserCredential?> login() {
    return datasource.login();
  }
  
  @override
  Future<void> logout() {
    return datasource.logout();
  }

  
}
