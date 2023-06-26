import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_provider.dart';

final firebaseUIDProvider = StateProvider(
  (ref) => ref.watch(firebaseRepositoryProvider).getUUID(),
);
