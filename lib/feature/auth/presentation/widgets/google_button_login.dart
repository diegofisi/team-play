import 'package:flutter/material.dart';
import 'package:team_play/feature/auth/domain/repositories/auth_repository_provisional.dart';

class GoogleButtonLogin extends StatelessWidget {
  final size;
  const GoogleButtonLogin({
    super.key, required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Image.asset(
        'assets/logo/google_logo.png',
        height: 20.0,
      ),
      label: const Text(
        'Sign in with Google',
      ),
      onPressed: () {
        AuthService().signInWithGoogle();
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
        ),
        backgroundColor: MaterialStateProperty.all(
          Colors.white,
        ),
        foregroundColor: MaterialStateProperty.all(
          Colors.black,
        ),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
