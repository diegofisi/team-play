import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:team_play/feature/auth/domain/repositories/auth_repository.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: TextButton(
          onPressed: () async {
            try {
              AuthService().signInWithGoogle();
            } catch (e) {
              return;
            }
          },
          child: Text("ingresar"),
        ),
      ),
    ]);
  }
}
