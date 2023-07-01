import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';
import 'package:team_play/feature/home/entities/game.dart';
import 'package:team_play/feature/home/models/game_request.dart';
import 'package:team_play/feature/home/models/game_response.dart';
import 'package:team_play/feature/shared/helpers/determine_position.dart';
import 'package:team_play/feature/shared/helpers/slider_search.dart';

class RegistrationService {
  final Dio dio = Dio();

  Future<void> createGame(GameRequest gameRequest) async {
    try {
      final token = await FirebaseAuth.instance.currentUser!.getIdToken();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.post('http://10.0.2.2:3000/api/playerSearches/',
          data: gameRequest.toJson());
    } catch (e) {
      return;
    }
  }

  Future<List<Game>> getNearGames() async {
    try {
      const Distance distance = Distance();
      const JsonEncoder encoder = JsonEncoder();
      final intialPosition = await determinePosition();
      final rangePosition = await getRadiusValue();
      final token = await FirebaseAuth.instance.currentUser!.getIdToken();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $token';
      final data = await dio.get('http://10.0.2.2:3000/api/playerSearches/');
      final gameResponse = gameResponseFromJson(encoder.convert(data.data));
      final games = gameResponse
          .map((response) => Game.fromGameResponse(response))
          .toList();
      final gamesNear = games
          .where((game) =>
              distance
                  .as(
                      LengthUnit.Kilometer,
                      LatLng(intialPosition.latitude, intialPosition.longitude),
                      LatLng(game.location.latitude, game.location.longitude))
                  .toDouble() <=
              rangePosition)
          .toList();
      return gamesNear;
    } catch (e) {
      return [];
    }
  }
}
