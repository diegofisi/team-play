import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:team_play/config/helpers/failure.dart';

abstract class AuthDataSource {
  Future<Either<Failure, User>> login();
}