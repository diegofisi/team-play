import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/auth/infrastructure/errors/failure.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_provider.dart';

final firebaseUIDProvider = StateNotifierProvider<UidNotifier, String?>(
  (ref) => UidNotifier(uid: ref.watch(firebaseRepositoryProvider).getUUID),
);

typedef GetUid = Either<Failure, String> Function();

class UidNotifier extends StateNotifier<String?> {
  final GetUid uid;
  UidNotifier({required this.uid}) : super(null);

  Future<String?> getUid() async {
    final failureOrUid = uid();
    failureOrUid.fold(
      (failure) => null,
      (uid) => {
        state = uid,
      },
    );
    return state;
  }

  void resetUid() {
    state = null;
  }
}
