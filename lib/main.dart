import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:team_play/feature/auth/domain/repositories/auth_repository.dart';
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
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: AuthService().handleAuthState(),
      ),
    );
  }
}
