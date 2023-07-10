import 'dart:convert';

import 'package:team_play/feature/shared/models/chat.dart';
import 'package:team_play/feature/shared/models/location.dart';

UserProfileResponse userProfileFromJson(String str) =>
    UserProfileResponse.fromJson(json.decode(str));

String userProfileToJson(UserProfileResponse data) =>
    json.encode(data.toJson());

class UserProfileResponse {
  final Location location;
  final String id;
  final String name;
  final String username;
  final String email;
  final String uid;
  final String role;
  final int age;
  final String position;
  final List<String> comments;
  final int v;
  final List<Chat> chats;

  UserProfileResponse({
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
    required this.v,
    required this.chats,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) =>
      UserProfileResponse(
        location: Location.fromJson(json["location"]),
        id: json["_id"],
        name: json["name"],
        username: json["username"],
        email: json["email"],
        uid: json["uid"],
        role: json["role"],
        age: json["age"],
        position: json["position"],
        comments: List<String>.from(json["comments"].map((x) => x)),
        v: json["__v"],
        chats: List<Chat>.from(json["chats"].map((x) => Chat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "_id": id,
        "name": name,
        "username": username,
        "email": email,
        "uid": uid,
        "role": role,
        "age": age,
        "position": position,
        "comments": List<dynamic>.from(comments.map((x) => x)),
        "__v": v,
        "chats": List<dynamic>.from(chats.map((x) => x.toJson())),
      };
}
