import 'package:flutter/material.dart';
import 'package:team_play/feature/auth/domain/repositories/auth_repository.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: () {
          AuthService().signInWithGoogle();
        },
        child: Text("ingresar"),
      ),
    );
  }
}
