import 'dart:convert';

ComentRequest comentRequestFromJson(String str) => ComentRequest.fromJson(json.decode(str));

String comentRequestToJson(ComentRequest data) => json.encode(data.toJson());

class ComentRequest {
    final String comment;
    final int rating;

    ComentRequest({
        required this.comment,
        required this.rating,
    });

    factory ComentRequest.fromJson(Map<String, dynamic> json) => ComentRequest(
        comment: json["comment"],
        rating: json["rating"],
    );

    Map<String, dynamic> toJson() => {
        "comment": comment,
        "rating": rating,
    };
}
