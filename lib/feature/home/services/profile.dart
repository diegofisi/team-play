import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:team_play/config/constants/environment.dart';
import 'package:team_play/feature/home/entities/profile.dart';
import 'package:team_play/feature/home/entities/user_profile.dart';
import 'package:team_play/feature/home/models/comment_request.dart';
import 'package:team_play/feature/home/models/profile_response.dart';
import 'package:team_play/feature/home/models/user_profile_response.dart';
import 'package:team_play/feature/shared/models/chat.dart';

import '../models/profile_update_request.dart';

class ProfileService {
  final Dio dio = Dio();

  Future<UserProfile> getUserProfile(String uid) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final token = await auth.currentUser!.getIdToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    final data = await dio.get('${Environment.urlApi}/api/users/$uid');
    final profileResponse = UserProfileResponse.fromJson(data.data);
    final profile = UserProfile.fromResponse(profileResponse);
    return profile;
  }

  Future<List<Chat>> getUserProfileMessage(String uid) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final token = await auth.currentUser!.getIdToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    final data = await dio.get('${Environment.urlApi}/api/users/$uid');
    final profileResponse = UserProfileResponse.fromJson(data.data);
    final profile = UserProfile.fromResponse(profileResponse);
    return profile.chats;
  }

  Future<Profile> getProfile(String id) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final token = await auth.currentUser!.getIdToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    final data = await dio.get('${Environment.urlApi}/api/users/profile/$id');
    final profileResponse = ProfileResponse.fromJson(data.data);
    final profile = Profile.fromResponse(profileResponse);
    return profile;
  }

  Future<void> postCommentary(String id, ComentRequest comment) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final token = await auth.currentUser!.getIdToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    await dio.post(
      '${Environment.urlApi}/api/comments/$id',
      data: comment.toJson(),
    );
  }

  Future<UserProfile> getUserByID(String id) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final token = await auth.currentUser!.getIdToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    final data = await dio.get('${Environment.urlApi}/api/users/$id');
    final userResponse = UserProfileResponse.fromJson(data.data);
    final user = UserProfile.fromResponse(userResponse);
    return user;
  }

  Future<void> updateProfile(String id, ProfileUpdateRequest profile) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      final token = await auth.currentUser!.getIdToken();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.put('${Environment.urlApi}/api/users/$id', data: profile);
    } catch (e) {
      return;
    }
  }

  Future<void> registerComment(String id, ComentRequest comment) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final token = await auth.currentUser!.getIdToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    await dio.post(
      '${Environment.urlApi}/api/comments/profile/$id',
      data: comment.toJson(),
    );
  }
}
