import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_provider.dart';

final firebaseUIDProvider = StateNotifierProvider<UidNotifier, String?>(
  (ref) => UidNotifier(uid: ref.watch(firebaseRepositoryProvider).getUUID),
);

typedef GetUid = String? Function();

class UidNotifier extends StateNotifier<String?> {
  final GetUid uid;
  UidNotifier({required this.uid}) : super(null);

  Future<String?> getUid() async {
    final failureOrUid = uid();
    return failureOrUid == null ? null : state = failureOrUid;
  }

  void resetUid() {
    state = null;
  }
}
