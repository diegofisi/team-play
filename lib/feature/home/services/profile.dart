import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:team_play/feature/home/entities/profile.dart';
import 'package:team_play/feature/home/entities/user_profile.dart';
import 'package:team_play/feature/home/models/comment_request.dart';
import 'package:team_play/feature/home/models/profile_response.dart';
import 'package:team_play/feature/home/models/user_profile_response.dart';

class ProfileService {
  final Dio dio = Dio();

  Future<UserProfile> getUserProfile(String uid) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final token = await auth.currentUser!.getIdToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    final data = await dio.get('http://10.0.2.2:3000/api/users/$uid');
    final profileResponse = UserProfileResponse.fromJson(data.data);
    final profile = UserProfile.fromResponse(profileResponse);
    return profile;
  }

  Future<Profile> getProfile(String id) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final token = await auth.currentUser!.getIdToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    final data = await dio.get('http://10.0.2.2:3000/api/users/profile/$id');
    final profileResponse = ProfileResponse.fromJson(data.data);
    final profile = Profile.fromResponse(profileResponse);
    return profile;
  }

  Future<void> registerComment(String id, ComentRequest comment) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final token = await auth.currentUser!.getIdToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    await dio.post(
      'http://10.0.2.2:3000/api/comments/profile/$id',
      data: comment.toJson(),
    );
  }
}
