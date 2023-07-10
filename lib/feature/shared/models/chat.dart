import 'package:team_play/feature/shared/models/messages.dart';

class Chat {
    final String userId;
    final List<Message> messages;
    final String id;

    Chat({
        required this.userId,
        required this.messages,
        required this.id,
    });

    factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        userId: json["userId"],
        messages: List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
        "_id": id,
    };
}