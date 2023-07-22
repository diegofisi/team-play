import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:team_play/config/constants/environment.dart';
import 'package:team_play/feature/auth/domain/datasources/auth_datasource_api.dart';
import 'package:team_play/feature/auth/domain/entities/user.dart';
import 'package:team_play/feature/auth/infrastructure/errors/failure.dart';
import 'package:team_play/feature/auth/infrastructure/mappers/user_mapper.dart';
import 'package:team_play/feature/auth/infrastructure/models/user_edit.dart';
import 'package:team_play/feature/auth/infrastructure/models/user_request.dart';
import 'package:team_play/feature/auth/infrastructure/models/user_response.dart';

class AuthDatasourceApiImpl extends AuthDataSourceApi {
  final Dio dio = Dio();

  @override
  Future<Either<Failure, UserEntity>> getUserAPI() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return Left(ServerFailure(400, 'User not logged'));
    }
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String? uid = user?.uid;
    final token = await FirebaseAuth.instance.currentUser!.getIdToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    final response = await dio.get('${Environment.urlApi}/api/users/$uid');
    final userEntity = userModeltoEntity(UserResponse.fromJson(response.data));
    return Right(userEntity);
  }

  @override
  Future<Either<Failure, bool>> isRegisterUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String? uid = user?.uid;
    final token = await FirebaseAuth.instance.currentUser!.getIdToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      await dio.get('${Environment.urlApi}/api/users/$uid');
      return const Right(true);
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<void> createUserAPI(UserRequest userRequest) async {
    try {
      final token = await FirebaseAuth.instance.currentUser!.getIdToken();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $token';
      print("usuario creado");
      await dio.post('${Environment.urlApi}/api/users/',
          data: userRequest.toJson());
    } catch (e) {
      print("usuario no creado");
      return;
    }
  }

  @override
  Future<void> editUserAPI(UserEdit userRequest) {
    // TODO: implement editUserAPI
    throw UnimplementedError();
  }
}
