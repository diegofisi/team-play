import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:team_play/feature/auth/domain/datasources/auth_datasource_firebase.dart';
import 'package:team_play/feature/auth/infrastructure/errors/failure.dart';

class AuthDatasourceFirebaseImpl extends AuthDataSourceFirebase {
  @override
  Future<Either<Failure, UserCredential>> login() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) {
        return Left(
          ServerFailure(
              400, 'El usuario canceló el proceso de inicio de sesión'),
        );
      }
      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: gAuth.idToken,
        accessToken: gAuth.accessToken,
      );
      return Right(
        await FirebaseAuth.instance.signInWithCredential(credential),
      );
    } on PlatformException catch (e) {
      return Left(
        ServerFailure(400, 'Caught a PlatformException: ${e.message}'),
      );
    } catch (e) {
      return Left(
        ServerFailure(400, '$e'),
      );
    }
  }

  @override
  Future<Either<Failure, String>> getToken() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return Left(ServerFailure(400, 'No se pudo obtener el currentUser'));
    }
    return Right(await FirebaseAuth.instance.currentUser!.getIdToken());
  }

  @override
  String? getUUID() {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String? uid = user?.uid;
    if (uid != null) {
      return uid;
    }
    return null;
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await GoogleSignIn().disconnect();
      await FirebaseAuth.instance.signOut();
      return const Right(true);
    } catch (error) {
      return const Right(false);
    }
  }
}
