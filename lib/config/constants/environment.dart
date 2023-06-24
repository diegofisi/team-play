import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String theMovieDBKey =
      dotenv.env['TEAM_PLAY_URL'] ?? 'Dont found api key';
}
