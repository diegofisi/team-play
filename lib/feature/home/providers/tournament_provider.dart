import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/home/models/tournament_request.dart';
import 'package:team_play/feature/home/providers/service_provider.dart';

final createTournamentProvider = FutureProvider.family<void, TournamentRequest>(
    (ref, tournamentRequest) async {
  await ref
      .watch(tournamentServiceProvider)
      .createTournament(tournamentRequest);
  return;
});
