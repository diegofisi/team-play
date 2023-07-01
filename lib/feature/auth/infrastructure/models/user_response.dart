import 'dart:convert';
import 'package:team_play/feature/shared/models/location.dart';

UserResponse userResponseFromJson(String str) => UserResponse.fromJson(json.decode(str));

class UserResponse {
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
    final int v;

    UserResponse({
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
    });

    factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        location: Location.fromJson(json["location"]),
        id: json["_id"],
        name: json["name"] ?? "error",
        username: json["username"] ?? "error",
        email: json["email"] ?? "error@error.com",
        uid: json["uid"],
        role: json["role"] ?? "error",
        age: json["age"] ?? 20,
        position: json["position"] ?? "error",
        comments: List<dynamic>.from(json["comments"].map((x) => x)),
        v: json["__v"],
    );
}
