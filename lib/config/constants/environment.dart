import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String urlApi =
      dotenv.env['URL_API'] ?? 'http://10.0.2.2:3000/';
}
