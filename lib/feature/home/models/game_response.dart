import 'dart:convert';

import 'package:team_play/feature/shared/models/create_by.dart';
import 'package:team_play/feature/shared/models/location.dart';

List<GameResponse> gameResponseFromJson(String str) => List<GameResponse>.from(json.decode(str).map((x) => GameResponse.fromJson(x)));

String gameResponseToJson(List<GameResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GameResponse {
    final Location location;
    final String id;
    final String positionNeeded;
    final CreatedBy createdBy;
    final DateTime matchDate;
    final String matchTime;
    final int fieldRentalPayment;
    final String? address;
    final String description;
    final DateTime createdAt;
    final DateTime updatedAt;
    final int v;
    final String? playerInterested;
    final String title;

    GameResponse({
        required this.location,
        required this.id,
        required this.positionNeeded,
        required this.createdBy,
        required this.matchDate,
        required this.matchTime,
        required this.fieldRentalPayment,
        this.address,
        required this.description,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
        this.playerInterested,
        required this.title,
    });

    factory GameResponse.fromJson(Map<String, dynamic> json) => GameResponse(
        location: Location.fromJson(json["location"]),
        id: json["_id"],
        positionNeeded: json["position_needed"],
        createdBy: CreatedBy.fromJson(json["created_by"]),
        matchDate: DateTime.parse(json["match_date"]),
        matchTime: json["match_time"],
        fieldRentalPayment: json["field_rental_payment"],
        address: json["address"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["__v"],
        playerInterested: json["player_interested"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "_id": id,
        "position_needed": positionNeeded,
        "created_by": createdBy.toJson(),
        "match_date": matchDate.toIso8601String(),
        "match_time": matchTime,
        "field_rental_payment": fieldRentalPayment,
        "address": address,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "__v": v,
        "player_interested": playerInterested,
        "title": title,
    };
}