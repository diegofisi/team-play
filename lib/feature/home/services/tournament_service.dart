import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';
import 'package:team_play/feature/home/entities/tournament.dart';
import 'package:team_play/feature/home/models/tournament_registration_request.dart';
import 'package:team_play/feature/home/models/tournament_response.dart';
import 'package:team_play/feature/shared/helpers/determine_position.dart';
import 'package:team_play/feature/shared/helpers/slider_search.dart';

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

  Future<List<Tournament>> getNearTournaments() async {
    try {
      const Distance distance = Distance();
      const JsonEncoder encoder = JsonEncoder();
      final intialPosition = await determinePosition();
      final rangePosition = await getRadiusValue();
      final token = await FirebaseAuth.instance.currentUser!.getIdToken();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $token';
      final data = await dio.get('http://10.0.2.2:3000/api/tournaments/');
      final tournamentResponse =
          tournamentByIdResponseFromJson(encoder.convert(data.data));
      final tournaments = tournamentResponse
          .map((response) =>
              Tournament.tournamentFromTournamentByIdResponse(response))
          .toList();
      final tournamentsNear = tournaments
          .where((game) =>
              distance
                  .as(
                      LengthUnit.Kilometer,
                      LatLng(intialPosition.latitude, intialPosition.longitude),
                      LatLng(game.location.latitude, game.location.longitude))
                  .toDouble() <=
              rangePosition)
          .toList();
      return tournamentsNear;
    } catch (e) {
      return [];
    }
  }

  Future<Tournament> getTournamentById(String id) async {
    final token = await FirebaseAuth.instance.currentUser!.getIdToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    final data = await dio.get('http://10.0.2.2:3000/api/tournaments/$id');
    final tournamentResponse = TournamentResponse.fromJson(data.data);
    final tournament =
        Tournament.tournamentFromTournamentByIdResponse(tournamentResponse);
    return tournament;
  }

  Future<void> deleteTournament(String id) async {
    final token = await FirebaseAuth.instance.currentUser!.getIdToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    await dio.delete('http://10.0.2.2:3000/api/tournaments/$id');
  }
}
