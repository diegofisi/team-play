import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/home/services/team.dart';

final teamServiceProvider = Provider((ref) => TeamService());

final teamRegisterProvider = FutureProvider.autoDispose.family<String, String>(
  (ref, id) async => await ref.watch(teamServiceProvider).teamRegister(id),
);