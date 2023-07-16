import 'dart:convert';
import 'package:team_play/feature/shared/models/location.dart';

GameRequest gameRequestFromJson(String str) =>
    GameRequest.fromJson(json.decode(str));

String gameRequestToJson(GameRequest data) => json.encode(data.toJson());

class GameRequest {
  final String? title;
  final String positionNeeded;
  final DateTime matchDate;
  final String matchTime;
  final double fieldRentalPayment;
  final Location location;
  final String description;

  GameRequest({
    this.title,
    required this.positionNeeded,
    required this.matchDate,
    required this.matchTime,
    required this.fieldRentalPayment,
    required this.location,
    required this.description,
  });

  factory GameRequest.fromJson(Map<String, dynamic> json) => GameRequest(
        title: json["title"] ?? "Mi partido",
        positionNeeded: json["position_needed"],
        matchDate: DateTime.parse(json["match_date"]),
        matchTime: json["match_time"],
        fieldRentalPayment: json["field_rental_payment"],
        location: Location.fromJson(json["location"]),
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title ?? "Mi partido",
        "position_needed": positionNeeded,
        "match_date":
            "${matchDate.year.toString().padLeft(4, '0')}-${matchDate.month.toString().padLeft(2, '0')}-${matchDate.day.toString().padLeft(2, '0')}",
        "match_time": matchTime,
        "field_rental_payment": fieldRentalPayment,
        "location": location.toJson(),
        "description": description,
      };
}
