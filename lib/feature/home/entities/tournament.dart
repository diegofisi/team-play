import 'package:team_play/feature/home/models/tournament_response.dart';

import '../../shared/models/location.dart';

class Tournament {
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

  Tournament({
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
  });

  factory Tournament.tournamentFromTournamentByIdResponse(
      TournamentResponse response) {
    return Tournament(
      location: response.location,
      id: response.id,
      name: response.name,
      createdBy: response.createdBy,
      rounds: response.rounds,
      matches: response.matches,
      roundMatches: response.roundMatches,
      isRoundComplete: response.isRoundComplete,
      date: response.date,
      time: response.time,
      inscription: response.inscription,
      prize: response.prize,
      teamCount: response.teamCount,
      teams: response.teams,
      winners: response.winners,
    );
  }
}
