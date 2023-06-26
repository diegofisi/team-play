import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/auth/infrastructure/datasources/auth_datasource_firebase_impl.dart';
import 'package:team_play/feature/auth/infrastructure/repositories/auth_repository_firebase_impl.dart';

final firebaseRepositoryProvider =
    Provider((ref) => AuthRepositoryFirebaseImpl(AuthDatasourceFirebaseImpl()));

// final firebaseLogoutProvider =
//     StateProvider((ref) => ref.watch(firebaseRepositoryProvider).logout());

// final firebaseUIDProvider =
//     StateProvider((ref) => ref.watch(firebaseRepositoryProvider).getUUID());

final firebaseTokenProvider =
    StateProvider((ref) => ref.watch(firebaseRepositoryProvider).getToken());

// final firebaseLoginProvider =
//     StateProvider((ref) => ref.watch(firebaseRepositoryProvider).login());
