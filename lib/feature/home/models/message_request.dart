import 'dart:convert';

MessageRequest comentRequestFromJson(String str) => MessageRequest.fromJson(json.decode(str));

String comentRequestToJson(MessageRequest data) => json.encode(data.toJson());

class MessageRequest {
    final String recipientId;
    final String message;

    MessageRequest({
        required this.recipientId,
        required this.message,
    });

    factory MessageRequest.fromJson(Map<String, dynamic> json) => MessageRequest(
        recipientId: json["recipientId"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "recipientId": recipientId,
        "message": message,
    };
}
