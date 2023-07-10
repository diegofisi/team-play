import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:team_play/feature/home/models/tournament_request.dart';
import 'package:team_play/feature/home/models/tournament_response.dart';

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

  // Future<List<TournamentResponse>> getAllTournaments() async {
  //   try {
  //     const JsonEncoder encoder = JsonEncoder();
  //     final token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //     dio.options.headers['content-Type'] = 'application/json';
  //     dio.options.headers['Authorization'] = 'Bearer $token';
  //     final data = await dio.get('http://10.0.2.2:3000/api/playerSearches/');
  //     final tournamentResponse = tournamentResponseFromJson(encoder.convert(data.data));
  //     final tournaments = tournamentResponse
  //         .map((response) => Game.fromGameResponse(response))
  //         .toList();
  //     final gamesNear = games
  //         .where((game) =>
  //             distance
  //                 .as(
  //                     LengthUnit.Kilometer,
  //                     LatLng(intialPosition.latitude, intialPosition.longitude),
  //                     LatLng(game.location.latitude, game.location.longitude))
  //                 .toDouble() <=
  //             rangePosition)
  //         .toList();
  //     return gamesNear;
  //   } catch (e) {
  //     return [];
  //   }
  // }
}
