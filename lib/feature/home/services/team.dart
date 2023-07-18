import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:team_play/config/constants/environment.dart';
import 'package:team_play/feature/home/models/team_request.dart';
import 'package:team_play/feature/home/models/team_response.dart';

class TeamService {
  final Dio dio = Dio();
  Future<String> teamRegister(String teamName) async {
    final token = await FirebaseAuth.instance.currentUser!.getIdToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    final team = TeamRequest(name: teamName);
    final data = await dio.post(
      '${Environment.urlApi}/api/teams',
      data: team.toJson(),
    );
    final teamResponse = TeamResponse.fromJson(data.data);
    return teamResponse.id;
  }
}
