import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:team_play/feature/home/models/tournament_request.dart';

class TournamentService {
  final Dio dio = Dio();

  Future<void> createTournament(TournamentRequest tournamentRequest) async {
    try {
      final token = await FirebaseAuth.instance.currentUser!.getIdToken();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.post('http://10.0.2.2:3000/api/tournaments',
          data: tournamentRequest.toJson());
    } catch (e) {
      return;
    }
  }

  Future<void> getTournaments() async {
    try {
      final token = await FirebaseAuth.instance.currentUser!.getIdToken();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.get('http://10.0.2.2:3000/api/tournaments');
    } catch (e) {
      return;
    }
  }

}
