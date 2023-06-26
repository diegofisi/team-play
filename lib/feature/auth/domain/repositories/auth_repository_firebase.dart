import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthDataRepositoryFirebase {
  Future<UserCredential?> login();
  Future<String?> getToken();
  String? getUUID();
  Future<void> logout();
  bool isLogin();
}
