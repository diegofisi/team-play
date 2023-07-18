import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';
import 'package:team_play/config/constants/environment.dart';
import 'package:team_play/feature/home/entities/tournament.dart';
import 'package:team_play/feature/home/models/accept_team_request.dart';
import 'package:team_play/feature/home/models/register_team_result_request.dart';
import 'package:team_play/feature/home/models/reject_team_request.dart';
import 'package:team_play/feature/home/models/tournament_registration_request.dart';
import 'package:team_play/feature/home/models/tournament_response.dart';
import 'package:team_play/feature/shared/helpers/determine_position.dart';
import 'package:team_play/feature/shared/helpers/slider_search.dart';

import '../models/tournament_register_request.dart';

class TournamentService {
  final Dio dio = Dio();

  Future<void> createTournament(TournamentRequest tournamentRequest) async {
    try {
      final token = await FirebaseAuth.instance.currentUser!.getIdToken();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.post('${Environment.urlApi}/api/tournaments',
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
      await dio.get('${Environment.urlApi}/api/tournaments');
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
      final data = await dio.get('${Environment.urlApi}/api/tournaments/');
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
    final data = await dio.get('${Environment.urlApi}/api/tournaments/$id');
    final tournamentResponse = TournamentResponse.fromJson(data.data);
    final tournament =
        Tournament.tournamentFromTournamentByIdResponse(tournamentResponse);
    return tournament;
  }

  Future<void> deleteTournament(String id) async {
    final token = await FirebaseAuth.instance.currentUser!.getIdToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    await dio.delete('${Environment.urlApi}/api/tournaments/$id');
  }

  Future<bool> registerTournament(
      String tournamentID, TournamentRegisterRequest request) async {
    try {
      final token = await FirebaseAuth.instance.currentUser!.getIdToken();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.post(
          '${Environment.urlApi}/api/tournaments/$tournamentID/add-team',
          data: request.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> registerResultMatch(
    String tournamentID,
    String matchID,
    RegisterTeamResultRequest register,
  ) async {
    try {
      final token = await FirebaseAuth.instance.currentUser!.getIdToken();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.put(
          '${Environment.urlApi}/api/tournaments/$tournamentID/matches/$matchID/register-result',
          data: register.toJson());
    } catch (e) {
      return;
    }
  }

  Future<void> generateNextRound(String tournamentId) async {
    try {
      final token = await FirebaseAuth.instance.currentUser!.getIdToken();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.post(
          '${Environment.urlApi}/api/tournaments/$tournamentId/generate-next-round');
    } catch (e) {
      return;
    }
  }

  Future<void> acceptTeam(String tournamentId, AcceptTeamRequest team) async {
    try {
      final token = await FirebaseAuth.instance.currentUser!.getIdToken();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.put(
        '${Environment.urlApi}/api/tournaments/$tournamentId/accept-team',
        data: team.toJson(),
      );
    } catch (e) {
      return;
    }
  }

  Future<void> rejectTeam(String tournamentId, RejectTeamRequest team) async {
    try {
      final token = await FirebaseAuth.instance.currentUser!.getIdToken();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.put(
        '${Environment.urlApi}/api/tournaments/$tournamentId/reject-team',
        data: team.toJson(),
      );
    } catch (e) {
      return;
    }
  }
}
