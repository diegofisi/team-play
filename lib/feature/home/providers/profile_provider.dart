import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/home/entities/profile.dart';
import 'package:team_play/feature/home/entities/user_profile.dart';
import 'package:team_play/feature/home/models/comment_request.dart';
import 'package:team_play/feature/home/services/profile.dart';

final profileSevice = Provider((ref) => ProfileService());

final getUserProfileProvider = FutureProvider.family<UserProfile, String>(
  (ref, uid) async => await ref.read(profileSevice).getUserProfile(uid),
);

final getProfileProvider = FutureProvider.family<Profile, String>(
  (ref, id) async => await ref.read(profileSevice).getProfile(id),
);

final registerCommentProvider =
    FutureProvider.family<void, Tuple2<String, ComentRequest>>(
  (ref, data) async =>
      await ref.read(profileSevice).registerComment(data.value1, data.value2),
);
