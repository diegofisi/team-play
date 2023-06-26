import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/auth/infrastructure/datasources/auth_datasource_api_impl.dart';
import 'package:team_play/feature/auth/infrastructure/repositories/auth_repository_api_impl.dart';

final userRepositoryProvider = Provider(
  (ref) => AuthRepositoryApiImpl(AuthDatasourceApiImpl()).getUserAPI(),
);

final isUserRegisterProvider = Provider(
  (ref) => AuthRepositoryApiImpl(AuthDatasourceApiImpl()).isRegisterUser(),
);