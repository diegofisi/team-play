import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/home/services/registration_service.dart';

final serviceProvider = Provider((ref) => RegistrationService());
