import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/auth/infrastructure/datasources/auth_datasource_firebase_impl.dart';
import 'package:team_play/feature/auth/infrastructure/repositories/auth_repository_firebase_impl.dart';

final getTokenProvider = Provider((ref) =>
    AuthRepositoryFirebaseImpl(AuthDatasourceFirebaseImpl()).getToken());

final loginProvider = Provider((ref) => 
    AuthRepositoryFirebaseImpl(AuthDatasourceFirebaseImpl()).login());