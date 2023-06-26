import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_login_provider.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_uid_provider.dart';
import 'package:team_play/feature/auth/presentation/providers/user_provider.dart';

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
      onPressed: () async {
        await ref.read(firebaseLoginProvider.notifier).login();
        final isUser = await ref
            .read(isUserRegisteredProvider.notifier)
            .getIsUserRegistered();
        final uid = ref.read(firebaseUIDProvider);
        isUser.fold(
          (fail) => {
            null,
          },
          (isUser) => {
            print("el isUser es: $isUser"),
            isUser ? context.go('/home/$uid') : context.go('/register'),
          },
        );
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
