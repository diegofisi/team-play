import 'dart:convert';

import '../../shared/models/location.dart';

List<TournamentResponse> tournamentByIdResponseFromJson(String str) =>
    List<TournamentResponse>.from(
        json.decode(str).map((x) => TournamentResponse.fromJson(x)));

String tournamentByIdResponseToJson(List<TournamentResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TournamentResponse {
  final Location location;
  final String id;
  final String name;
  final String createdBy;
  final int rounds;
  final List<Match> matches;
  final List<String> roundMatches;
  final bool isRoundComplete;
  final DateTime date;
  final String time;
  final int inscription;
  final int prize;
  final int teamCount;
  final List<TeamElement> teams;
  final List<Winner> winners;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  TournamentResponse({
    required this.location,
    required this.id,
    required this.name,
    required this.createdBy,
    required this.rounds,
    required this.matches,
    required this.roundMatches,
    required this.isRoundComplete,
    required this.date,
    required this.time,
    required this.inscription,
    required this.prize,
    required this.teamCount,
    required this.teams,
    required this.winners,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory TournamentResponse.fromJson(Map<String, dynamic> json) =>
      TournamentResponse(
        location: Location.fromJson(json["location"]),
        id: json["_id"],
        name: json["name"],
        createdBy: json["created_by"],
        rounds: json["rounds"],
        matches:
            List<Match>.from(json["matches"].map((x) => Match.fromJson(x))),
        roundMatches: List<String>.from(json["roundMatches"].map((x) => x)),
        isRoundComplete: json["isRoundComplete"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        inscription: json["inscription"],
        prize: json["prize"],
        teamCount: json["teamCount"],
        teams: List<TeamElement>.from(
            json["teams"].map((x) => TeamElement.fromJson(x))),
        winners:
            List<Winner>.from(json["winners"].map((x) => Winner.fromJson(x))),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "_id": id,
        "name": name,
        "created_by": createdBy,
        "rounds": rounds,
        "matches": List<dynamic>.from(matches.map((x) => x.toJson())),
        "roundMatches": List<dynamic>.from(roundMatches.map((x) => x)),
        "isRoundComplete": isRoundComplete,
        "date": date.toIso8601String(),
        "time": time,
        "inscription": inscription,
        "prize": prize,
        "teamCount": teamCount,
        "teams": List<dynamic>.from(teams.map((x) => x.toJson())),
        "winners": List<dynamic>.from(winners.map((x) => x.toJson())),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class Match {
  final String id;
  final int round;
  final String result;
  final Team1Class team1;
  final Team1Class team2;

  Match({
    required this.id,
    required this.round,
    required this.result,
    required this.team1,
    required this.team2,
  });

  factory Match.fromJson(Map<String, dynamic> json) => Match(
        id: json["_id"],
        round: json["round"],
        result: json["result"],
        team1: Team1Class.fromJson(json["team1"]),
        team2: Team1Class.fromJson(json["team2"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "round": round,
        "result": result,
        "team1": team1.toJson(),
        "team2": team2.toJson(),
      };
}

class Team1Class {
  final String id;
  final String name;

  Team1Class({
    required this.id,
    required this.name,
  });

  factory Team1Class.fromJson(Map<String, dynamic> json) => Team1Class(
        id: json["_id"] ?? "",
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

class TeamElement {
  final Team1Class team;
  final String state;
  final String voucher;
  final String id;

  TeamElement({
    required this.team,
    required this.state,
    required this.voucher,
    required this.id,
  });

  factory TeamElement.fromJson(Map<String, dynamic> json) => TeamElement(
        team: Team1Class.fromJson(json["team"]),
        state: json["state"],
        voucher: json["voucher"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "team": team.toJson(),
        "state": state,
        "voucher": voucher,
        "_id": id,
      };
}

class Winner {
  final String matchId;
  final String teamId;

  Winner({
    required this.matchId,
    required this.teamId,
  });

  factory Winner.fromJson(Map<String, dynamic> json) => Winner(
        matchId: json["matchId"],
        teamId: json["teamId"],
      );

  Map<String, dynamic> toJson() => {
        "matchId": matchId,
        "teamId": teamId,
      };
}
