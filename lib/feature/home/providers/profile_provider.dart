import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/home/entities/profile.dart';
import 'package:team_play/feature/home/entities/user_profile.dart';
import 'package:team_play/feature/home/models/comment_request.dart';
import 'package:team_play/feature/home/models/profile_update_request.dart';
import 'package:team_play/feature/home/services/profile.dart';
import 'package:team_play/feature/shared/models/chat.dart';

final profileSevice = Provider((ref) => ProfileService());

final getUserProfileProvider =
    FutureProvider.autoDispose.family<UserProfile, String>(
  (ref, uid) async => await ref.read(profileSevice).getUserProfile(uid),
);

final getProfileProvider = FutureProvider.autoDispose.family<Profile, String>(
  (ref, id) async => await ref.read(profileSevice).getProfile(id),
);

final getUserProfileMessageProvider =
    FutureProvider.autoDispose.family<List<Chat>, String>(
  (ref, uid) async => await ref.read(profileSevice).getUserProfileMessage(uid),
);

final profileUpdateProvider =
    FutureProvider.family<void, Tuple2<String, ProfileUpdateRequest>>(
  (ref, data) async =>
      await ref.read(profileSevice).updateProfile(data.value1, data.value2),
);

final getUserByIDProvider =
    FutureProvider.autoDispose.family<UserProfile, String>(
  (ref, id) async => await ref.read(profileSevice).getUserByID(id),
);

final postCommentaryProvider =
    FutureProvider.autoDispose.family<void, Tuple2<String, ComentRequest>>(
  (ref, data) async =>
      await ref.read(profileSevice).postCommentary(data.value1, data.value2),
);
