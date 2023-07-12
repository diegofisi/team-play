import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/home/models/message_request.dart';
import 'package:team_play/feature/home/services/message_service.dart';

final messageSevice = Provider((ref) => MessageService());

final messageSeviceProvider =
    FutureProvider.autoDispose.family<void, MessageRequest>(
  (ref, message) async => await ref.read(messageSevice).createMessage(message),
);
