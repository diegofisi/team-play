import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:team_play/config/theme/app_theme.dart';
import 'package:team_play/feature/auth/domain/repositories/auth_repository_provisional.dart';
import 'package:team_play/feature/auth/presentation/screens/login2.dart';
import 'package:team_play/feature/auth/presentation/screens/token_print.dart';
import 'package:team_play/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        body: TokenPrint(),
      ),
      theme: AppTheme().getTheme(),
    );
  }
}
