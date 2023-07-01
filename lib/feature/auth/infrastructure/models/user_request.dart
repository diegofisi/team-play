import 'dart:convert';
import 'package:team_play/feature/shared/models/location.dart';

UserRequest userRequestFromJson(String str) =>
    UserRequest.fromJson(json.decode(str));

String userRequestToJson(UserRequest data) => json.encode(data.toJson());

class UserRequest {
  final String name;
  final String username;
  final String email;
  final String? role;
  final int age;
  final String position;
  final Location location;

  UserRequest({
    required this.name,
    required this.username,
    required this.email,
    this.role = "user",
    required this.age,
    required this.position,
    required this.location,
  });

  factory UserRequest.fromJson(Map<String, dynamic> json) => UserRequest(
        name: json["name"],
        username: json["username"],
        email: json["email"],
        role: json["role"],
        age: json["age"],
        position: json["position"],
        location: Location.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "username": username,
        "email": email,
        "role": role,
        "age": age,
        "position": position,
        "location": location.toJson(),
      };
}

