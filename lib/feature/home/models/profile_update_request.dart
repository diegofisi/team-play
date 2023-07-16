import 'dart:convert';

ProfileUpdateRequest updateProfileRequestFromJson(String str) => ProfileUpdateRequest.fromJson(json.decode(str));

String updateProfileRequestToJson(ProfileUpdateRequest data) => json.encode(data.toJson());

class ProfileUpdateRequest {
    final String name;
    final String username;
    final String position;
    final int age;

    ProfileUpdateRequest({
        required this.name,
        required this.username,
        required this.position,
        required this.age,
    });

    factory ProfileUpdateRequest.fromJson(Map<String, dynamic> json) => ProfileUpdateRequest(
        name: json["name"],
        username: json["username"],
        position: json["position"],
        age: json["age"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "username": username,
        "position": position,
        "age": age,
    };
}
