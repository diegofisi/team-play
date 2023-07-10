class Message {
    final String sender;
    final String recipient;
    final String content;
    final String id;

    Message({
        required this.sender,
        required this.recipient,
        required this.content,
        required this.id,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        sender: json["sender"],
        recipient: json["recipient"],
        content: json["content"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "sender": sender,
        "recipient": recipient,
        "content": content,
        "_id": id,
    };
}