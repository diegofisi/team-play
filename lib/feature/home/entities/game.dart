import 'package:team_play/feature/home/models/game_response.dart';
import 'package:team_play/feature/shared/models/create_by.dart';
import 'package:team_play/feature/shared/models/location.dart';

class Game {
  final Location location;
  final String nameGame;
  final String id;
  final String positionNeeded;
  final CreatedBy createdBy;
  final DateTime matchDate;
  final String matchTime;
  final double fieldRentalPayment;
  final String description;
  final String? playerInterested;
  final String title;

  Game({
    required this.nameGame,
    required this.location,
    required this.id,
    required this.positionNeeded,
    required this.createdBy,
    required this.matchDate,
    required this.matchTime,
    required this.fieldRentalPayment,
    required this.description,
    this.playerInterested,
    required this.title,
  });

  factory Game.fromGameResponse(GameResponse response) {
    return Game(
      nameGame: response.title,
      location: response.location,
      id: response.id,
      positionNeeded: response.positionNeeded,
      createdBy: response.createdBy,
      matchDate: response.matchDate,
      matchTime: response.matchTime,
      fieldRentalPayment: response.fieldRentalPayment,
      description: response.description,
      playerInterested: response.playerInterested,
      title: response.title,
    );
  }
}
