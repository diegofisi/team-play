import 'dart:convert';

AcceptTeamRequest acceptTeamRequestFromJson(String str) => AcceptTeamRequest.fromJson(json.decode(str));

String acceptTeamRequestToJson(AcceptTeamRequest data) => json.encode(data.toJson());

class AcceptTeamRequest {
    final String teamId;

    AcceptTeamRequest({
        required this.teamId,
    });

    factory AcceptTeamRequest.fromJson(Map<String, dynamic> json) => AcceptTeamRequest(
        teamId: json["teamId"],
    );

    Map<String, dynamic> toJson() => {
        "teamId": teamId,
    };
}
