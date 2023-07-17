import 'dart:convert';

TournamentRegisterRequest tournamentRegisterRequestFromJson(String str) =>
    TournamentRegisterRequest.fromJson(json.decode(str));

String tournamentRegisterRequestToJson(TournamentRegisterRequest data) =>
    json.encode(data.toJson());

class TournamentRegisterRequest {
  final String teamId;
  final String voucher;

  TournamentRegisterRequest({
    required this.teamId,
    required this.voucher,
  });

  factory TournamentRegisterRequest.fromJson(Map<String, dynamic> json) =>
      TournamentRegisterRequest(
        teamId: json["teamId"],
        voucher: json["voucher"],
      );

  Map<String, dynamic> toJson() => {
        "teamId": teamId,
        "voucher": voucher,
      };
}
