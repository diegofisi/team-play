import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/home/entities/tournament.dart';
import 'package:team_play/feature/home/models/accept_team_request.dart';
import 'package:team_play/feature/home/models/register_team_result_request.dart';
import 'package:team_play/feature/home/models/reject_team_request.dart';
import 'package:team_play/feature/home/models/tournament_register_request.dart';
import 'package:team_play/feature/home/models/tournament_registration_request.dart';
import 'package:team_play/feature/home/providers/service_provider.dart';

final createTournamentProvider = FutureProvider.family<void, TournamentRequest>(
    (ref, tournamentRequest) async {
  await ref
      .watch(tournamentServiceProvider)
      .createTournament(tournamentRequest);
  return;
});

final getTournamentsProvider = FutureProvider.autoDispose<List<Tournament>>(
  (ref) async =>
      await ref.watch(tournamentServiceProvider).getNearTournaments(),
);

final getTournamentProvider =
    FutureProvider.autoDispose.family<Tournament, String>(
  (ref, gameId) async =>
      await ref.watch(tournamentServiceProvider).getTournamentById(gameId),
);

final registerTournamentProvider =
    FutureProvider.family<bool, Tuple2<String, TournamentRegisterRequest>>(
  (ref, data) async => await ref
      .read(tournamentServiceProvider)
      .registerTournament(data.value1, data.value2),
);

final deleteTournamentProvider = FutureProvider.family<void, String>(
  (ref, tournamentId) async =>
      await ref.watch(tournamentServiceProvider).deleteTournament(tournamentId),
);

final acceptTeamProvider =
    FutureProvider.autoDispose.family<void, Tuple2<String, AcceptTeamRequest>>(
  (ref, data) async => await ref
      .read(tournamentServiceProvider)
      .acceptTeam(data.value1, data.value2),
);

final rejectTeamProvider =
    FutureProvider.autoDispose.family<void, Tuple2<String, RejectTeamRequest>>(
  (ref, data) async => await ref
      .read(tournamentServiceProvider)
      .rejectTeam(data.value1, data.value2),
);

final registerResultMatchProvider = FutureProvider.family
    .autoDispose<void, Tuple3<String, String, RegisterTeamResultRequest>>(
  (ref, data) async => await ref
      .read(tournamentServiceProvider)
      .registerResultMatch(data.value1, data.value2, data.value3),
);

final generateNextRoundProvider =
    FutureProvider.autoDispose.family<void, String>(
  (ref, tournamentId) async =>
      await ref.read(tournamentServiceProvider).generateNextRound(tournamentId),
);
