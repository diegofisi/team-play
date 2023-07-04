import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/home/services/game_service.dart';
import 'package:team_play/feature/home/services/tournament_service.dart';

final gameServiceProvider = Provider((ref) => GameService());

final tournamentServiceProvider = Provider((ref) => TournamentService());
