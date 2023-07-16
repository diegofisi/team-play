import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:team_play/feature/home/entities/game.dart';
import 'package:team_play/feature/home/models/game_request.dart';
import 'package:team_play/feature/home/providers/service_provider.dart';

final createGameProvider =
    FutureProvider.family<void, GameRequest>((ref, gameRequest) async {
  await ref.watch(gameServiceProvider).createGame(gameRequest);
  return;
});

final getGamesProvider = FutureProvider.autoDispose<List<Game>>(
  (ref) async => await ref.read(gameServiceProvider).getNearGames(),
);

final getGameProvider = FutureProvider.autoDispose.family<Game, String>(
  (ref, gameId) async => await ref.read(gameServiceProvider).getGame(gameId),
);

final deleteGameProvider = FutureProvider.family<void, String>(
  (ref, gameId) async => await ref.read(gameServiceProvider).deleteGame(gameId),
);

final registerGameProvider =
    FutureProvider.family<void, Tuple2<String, String>>(
  (ref, data) async => await ref
      .read(gameServiceProvider)
      .registerGame(data.value1, data.value2),
);


final gamesListProvider = StateProvider<List<Game>>((ref) => []);
