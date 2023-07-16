import 'dart:convert';

RegisterRequest registerRequestFromJson(String str) => RegisterRequest.fromJson(json.decode(str));

String registerRequestToJson(RegisterRequest data) => json.encode(data.toJson());

class RegisterRequest {
    final String userId;

    RegisterRequest({
        required this.userId,
    });

    factory RegisterRequest.fromJson(Map<String, dynamic> json) => RegisterRequest(
        userId: json["userId"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
    };
}
