import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:team_play/config/helpers/failure.dart';
import 'package:team_play/feature/auth/domain/datasources/auth_datasource_firebase.dart';

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
    return Right(await FirebaseAuth.instance.currentUser!.getIdToken());
  }
}
