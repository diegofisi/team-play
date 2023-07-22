import 'package:team_play/feature/home/models/profile_response.dart';
import 'package:team_play/feature/shared/models/comment.dart';

class Profile {
  final String name;
  final int age;
  final String position;
  final double? rating;
  final List<Comment> comments;

  Profile({
    required this.name,
    required this.age,
    required this.position,
    this.rating,
    required this.comments,
  });

  Profile.fromResponse(ProfileResponse response)
      : name = response.name,
        age = response.age,
        position = response.position,
        rating = response.rating ?? 0.0,
        comments = response.comments;
}
