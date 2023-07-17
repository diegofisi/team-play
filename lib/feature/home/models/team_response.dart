import 'dart:convert';

TeamResponse teamResponseFromJson(String str) => TeamResponse.fromJson(json.decode(str));

String teamResponseToJson(TeamResponse data) => json.encode(data.toJson());

class TeamResponse {
    final String name;
    final List<dynamic> members;
    final String id;
    final DateTime createdAt;
    final DateTime updatedAt;
    final String creator;
    final int v;

    TeamResponse({
        required this.name,
        required this.members,
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.creator,
        required this.v,
    });

    factory TeamResponse.fromJson(Map<String, dynamic> json) => TeamResponse(
        name: json["name"],
        members: List<dynamic>.from(json["members"].map((x) => x)),
        id: json["_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        creator: json["creator"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "members": List<dynamic>.from(members.map((x) => x)),
        "_id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "creator": creator,
        "__v": v,
    };
}