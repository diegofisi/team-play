import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/config/helpers/failure.dart';
import 'package:team_play/feature/auth/infrastructure/datasources/auth_datasource_firebase_impl.dart';
import 'package:team_play/feature/auth/infrastructure/repositories/auth_repository_firebase_impl.dart';

// final getTokenProvider = Provider((ref) =>
//     AuthRepositoryFirebaseImpl(AuthDatasourceFirebaseImpl()).getToken());

// final loginProvider = StateProvider(
//     (ref) => AuthRepositoryFirebaseImpl(AuthDatasourceFirebaseImpl()).login());

// final getUUIDProvider = Provider((ref) =>
//     AuthRepositoryFirebaseImpl(AuthDatasourceFirebaseImpl()).getUUID());

// final logoutProvider = Provider(
//     (ref) => AuthRepositoryFirebaseImpl(AuthDatasourceFirebaseImpl()).logout());

// final isLoginProvider = StateProvider((ref) =>
//     AuthRepositoryFirebaseImpl(AuthDatasourceFirebaseImpl()).isLogin());

// final isLoginProvider2 = StreamProvider.autoDispose<User?>((ref) {
//   return FirebaseAuth.instance.authStateChanges();
// });

// final logoutProvider2 = FutureProvider.autoDispose<void>((ref) {
//   return FirebaseAuth.instance.signOut();
// });

final firebaseRepositoryProvider =
    Provider((ref) => AuthRepositoryFirebaseImpl(AuthDatasourceFirebaseImpl()));
