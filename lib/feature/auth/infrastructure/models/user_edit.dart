import 'dart:convert';

UserEdit userRequestFromJson(String str) =>
    UserEdit.fromJson(json.decode(str));

String userRequestToJson(UserEdit data) => json.encode(data.toJson());

class UserEdit {
  final String? name;
  final String? username;
  final String? email;
  final int? age;
  final String? position;

  UserEdit({
    required this.name,
    required this.username,
    required this.email,
    required this.age,
    required this.position,
  });

  factory UserEdit.fromJson(Map<String, dynamic> json) => UserEdit(
        name: json["name"],
        username: json["username"],
        email: json["email"],
        age: json["age"],
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "username": username,
        "email": email,
        "age": age,
        "position": position,
      };
}

