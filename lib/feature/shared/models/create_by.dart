class CreatedBy {
  final String id;
  final String username;

  CreatedBy({
    required this.id,
    required this.username,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["_id"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
      };
}