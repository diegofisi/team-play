import 'package:team_play/feature/home/models/user_profile_response.dart';
import 'package:team_play/feature/shared/models/chat.dart';
import 'package:team_play/feature/shared/models/location.dart';

class UserProfile {
  final Location location;
  final String id;
  final String name;
  final String username;
  final String email;
  final String uid;
  final String role;
  final int age;
  final String position;
  final List<dynamic> comments;
  final List<Chat> chats;

  UserProfile({
    required this.location,
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.uid,
    required this.role,
    required this.age,
    required this.position,
    required this.comments,
    required this.chats,
  });

  UserProfile.fromResponse(UserProfileResponse response)
      : location = response.location,
        id = response.id,
        name = response.name,
        username = response.username,
        email = response.email,
        uid = response.uid,
        role = response.role,
        age = response.age,
        position = response.position,
        comments = response.comments,
        chats = response.chats;
}
