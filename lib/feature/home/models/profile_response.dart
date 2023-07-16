import 'dart:convert';

import 'package:team_play/feature/shared/models/comment.dart';

ProfileResponse profileResponseFromJson(String str) =>
    ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) =>
    json.encode(data.toJson());

class ProfileResponse {
  final String name;
  final int age;
  final String position;
  final double? rating;
  final List<Comment> comments;

  ProfileResponse({
    required this.name,
    required this.age,
    required this.position,
    this.rating,
    required this.comments,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      ProfileResponse(
        name: json["name"],
        age: json["age"],
        position: json["position"],
        rating: json["rating"].toDouble() ?? 0.0,
        comments: List<Comment>.from(
            json["comments"].map((x) => Comment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "age": age,
        "position": position,
        "rating": rating,
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
      };
}
