import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/home/entities/tournament.dart';
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


final deleteTournamentProvider = FutureProvider.family<void, String>(
  (ref, tournamentId) async => await ref.watch(tournamentServiceProvider).deleteTournament(tournamentId),
);