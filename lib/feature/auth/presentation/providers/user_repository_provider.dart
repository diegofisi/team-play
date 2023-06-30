import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/auth/infrastructure/datasources/auth_datasource_api_impl.dart';
import 'package:team_play/feature/auth/infrastructure/repositories/auth_repository_api_impl.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepositoryApiImpl(AuthDatasourceApiImpl()),
);
