import 'dart:convert';

RegisterTeamResultRequest registerTeamRequestFromJson(String str) => RegisterTeamResultRequest.fromJson(json.decode(str));

String registerTeamRequestToJson(RegisterTeamResultRequest data) => json.encode(data.toJson());

class RegisterTeamResultRequest {
    final String teamId;
    final String result;

    RegisterTeamResultRequest({
        required this.teamId,
        required this.result,
    });

    factory RegisterTeamResultRequest.fromJson(Map<String, dynamic> json) => RegisterTeamResultRequest(
        teamId: json["teamId"],
        result: json["result"],
    );

    Map<String, dynamic> toJson() => {
        "teamId": teamId,
        "result": result,
    };
}
