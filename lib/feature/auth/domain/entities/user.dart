import 'dart:convert';

UserEntity userRequestFromJson(String str) =>
    UserEntity.fromJson(json.decode(str));

String userRequestToJson(UserEntity data) => json.encode(data.toJson());

class UserEntity {
  final String name;
  final String username;
  final String email;
  final String role;
  final int age;
  final String position;
  final LocationUser location;
  final String id;

  UserEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.role,
    required this.age,
    required this.position,
    required this.location,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
        id: json["_id"],
        name: json["name"],
        username: json["username"],
        email: json["email"],
        role: json["role"],
        age: json["age"],
        position: json["position"],
        location: LocationUser.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "username": username,
        "email": email,
        "role": role,
        "age": age,
        "position": position,
        "location": location.toJson(),
      };
}

class LocationUser {
  final double latitude;
  final double longitude;

  LocationUser({
    required this.latitude,
    required this.longitude,
  });

  factory LocationUser.fromJson(Map<String, dynamic> json) => LocationUser(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}
