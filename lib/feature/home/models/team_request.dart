import 'dart:convert';

TeamRequest teamRequestFromJson(String str) => TeamRequest.fromJson(json.decode(str));

String teamRequestToJson(TeamRequest data) => json.encode(data.toJson());

class TeamRequest {
    final String name;

    TeamRequest({
        required this.name,
    });

    factory TeamRequest.fromJson(Map<String, dynamic> json) => TeamRequest(
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
    };
}
