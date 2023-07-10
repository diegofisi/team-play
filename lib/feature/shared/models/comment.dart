class Comment {
    final String id;
    final String comment;
    final int rating;
    final int v;

    Comment({
        required this.id,
        required this.comment,
        required this.rating,
        required this.v,
    });

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["_id"],
        comment: json["comment"],
        rating: json["rating"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "comment": comment,
        "rating": rating,
        "__v": v,
    };
}