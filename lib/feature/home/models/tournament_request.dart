import 'dart:convert';

import 'package:team_play/feature/shared/models/location.dart';

TournamentRequest tournamentRequestFromJson(String str) => TournamentRequest.fromJson(json.decode(str));

String tournamentRequestToJson(TournamentRequest data) => json.encode(data.toJson());

class TournamentRequest {
    final String name;
    final DateTime date;
    final String time;
    final int inscription;
    final int prize;
    final Location location;
    final int teamCount;

    TournamentRequest({
        required this.name,
        required this.date,
        required this.time,
        required this.inscription,
        required this.prize,
        required this.location,
        required this.teamCount,
    });

    factory TournamentRequest.fromJson(Map<String, dynamic> json) => TournamentRequest(
        name: json["name"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        inscription: json["inscription"],
        prize: json["prize"],
        location: Location.fromJson(json["location"]),
        teamCount: json["teamCount"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "time": time,
        "inscription": inscription,
        "prize": prize,
        "location": location.toJson(),
        "teamCount": teamCount,
    };
}
