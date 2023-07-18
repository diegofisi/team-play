import 'dart:convert';

RejectTeamRequest rejectTeamRequestFromJson(String str) => RejectTeamRequest.fromJson(json.decode(str));

String rejectTeamRequestToJson(RejectTeamRequest data) => json.encode(data.toJson());

class RejectTeamRequest {
    final String teamId;

    RejectTeamRequest({
        required this.teamId,
    });

    factory RejectTeamRequest.fromJson(Map<String, dynamic> json) => RejectTeamRequest(
        teamId: json["teamId"],
    );

    Map<String, dynamic> toJson() => {
        "teamId": teamId,
    };
}
