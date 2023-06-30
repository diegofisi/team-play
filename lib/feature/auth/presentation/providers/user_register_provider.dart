import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/auth/infrastructure/models/user_request.dart';
import 'package:team_play/feature/auth/presentation/providers/user_repository_provider.dart';

final createUserProvider =
    FutureProvider.family<void, UserRequest>((ref, userRequest) async {
  await ref.watch(authRepositoryProvider).createUserAPI(userRequest);
  print("una vez mas desde el provider");
  return;
});
