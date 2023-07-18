import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:team_play/config/constants/environment.dart';
import 'package:team_play/feature/home/models/message_request.dart';

class MessageService {
  final Dio dio = Dio();
  Future<void> createMessage(MessageRequest message) async {
    try {
      final token = await FirebaseAuth.instance.currentUser!.getIdToken();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.post(
        '${Environment.urlApi}/api/users/send-message/',
        data: message.toJson(),
      );
    } catch (e) {
      return;
    }
  }
}
