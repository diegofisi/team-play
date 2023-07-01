import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/home/entities/game.dart';
import 'package:team_play/feature/home/models/game_request.dart';
import 'package:team_play/feature/home/providers/service_provider.dart';

final createGameProvider =
    FutureProvider.family<void, GameRequest>((ref, gameRequest) async {
  await ref.watch(serviceProvider).createGame(gameRequest);
  return;
});

final getGamesProvider = FutureProvider.autoDispose<List<Game>>(
  (ref) async => await ref.read(serviceProvider).getNearGames(),
);
