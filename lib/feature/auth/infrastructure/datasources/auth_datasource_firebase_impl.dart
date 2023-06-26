import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:team_play/config/helpers/failure.dart';
import 'package:team_play/feature/auth/domain/datasources/auth_datasource_firebase.dart';

class AuthDatasourceFirebaseImpl extends AuthDataSourceFirebase {

  @override
  Future<UserCredential?> login() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        return null;
        // return Left(
        //   ServerFailure(
        //       400, 'El usuario canceló el proceso de inicio de sesión'),
        // );
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: gAuth.idToken,
        accessToken: gAuth.accessToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
      // return Right(
      // );
    } on PlatformException catch (e) {
      return Future.error(e);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<String?> getToken() async {
    return await FirebaseAuth.instance.currentUser!.getIdToken();
  }

  @override
  String? getUUID() {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String? uid = user?.uid;
    if (uid != null) return uid;
    return null;
  }

  @override
  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      return await FirebaseAuth.instance.signOut();
    } catch (error) {
      return Future.error(error);
    }
  }

  @override
  bool isLogin() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("ola");
      return true;
    }
    print("adios");
    return false;
  }
}
