import 'package:team_play/feature/auth/domain/entities/user.dart';
import 'package:team_play/feature/auth/infrastructure/models/user_response.dart';

UserEntity userModeltoEntity(UserResponse userResponse) {
  return UserEntity(
    name: userResponse.name,
    username: userResponse.username,
    email: userResponse.email,
    role: userResponse.role,
    age: userResponse.age,
    position: userResponse.position,
    location: LocationUser(
      latitude: userResponse.location.latitude,
      longitude: userResponse.location.longitude,
    ),
  );
}
