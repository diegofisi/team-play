import 'dart:convert';

User userRequestFromJson(String str) => User.fromJson(json.decode(str));

String userRequestToJson(User data) => json.encode(data.toJson());

class User {
  final String name;
  final String username;
  final String email;
  final String role;
  final int age;
  final String position;
  final Location? location;

  User({
    required this.name,
    required this.username,
    required this.email,
    required this.role,
    required this.age,
    required this.position,
    this.location,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
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
        "location": location?.toJson() ?? {},
      };
}

class Location {
  final double latitude;
  final double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}
