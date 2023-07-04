import 'dart:convert';

List<TournamentResponse> tournamentResponseFromJson(String str) => List<TournamentResponse>.from(json.decode(str).map((x) => TournamentResponse.fromJson(x)));

String tournamentResponseToJson(List<TournamentResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TournamentResponse {
    final String id;
    final String name;
    final List<dynamic> teams;
    final String createdBy;
    final int rounds;
    final List<dynamic> matches;
    final List<dynamic> roundMatches;
    final bool isRoundComplete;
    final List<dynamic> winners;
    final DateTime createdAt;
    final DateTime updatedAt;
    final int v;

    TournamentResponse({
        required this.id,
        required this.name,
        required this.teams,
        required this.createdBy,
        required this.rounds,
        required this.matches,
        required this.roundMatches,
        required this.isRoundComplete,
        required this.winners,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    factory TournamentResponse.fromJson(Map<String, dynamic> json) => TournamentResponse(
        id: json["_id"],
        name: json["name"],
        teams: List<dynamic>.from(json["teams"].map((x) => x)),
        createdBy: json["created_by"],
        rounds: json["rounds"],
        matches: List<dynamic>.from(json["matches"].map((x) => x)),
        roundMatches: List<dynamic>.from(json["roundMatches"].map((x) => x)),
        isRoundComplete: json["isRoundComplete"],
        winners: List<dynamic>.from(json["winners"].map((x) => x)),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "teams": List<dynamic>.from(teams.map((x) => x)),
        "created_by": createdBy,
        "rounds": rounds,
        "matches": List<dynamic>.from(matches.map((x) => x)),
        "roundMatches": List<dynamic>.from(roundMatches.map((x) => x)),
        "isRoundComplete": isRoundComplete,
        "winners": List<dynamic>.from(winners.map((x) => x)),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "__v": v,
    };
}