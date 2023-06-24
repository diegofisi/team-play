import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/auth/domain/repositories/auth_repository_provisional.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_provider.dart';

class GoogleButtonLogin extends ConsumerWidget {
  const GoogleButtonLogin({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      icon: Image.asset(
        'assets/logo/google_logo.png',
        height: 30,
      ),
      label: const Text(
        'Sign in with Google',
      ),
      onPressed: () {
        ref.read(loginProvider);
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
