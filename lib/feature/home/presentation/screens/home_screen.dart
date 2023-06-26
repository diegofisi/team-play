import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_logout_provider.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_provider.dart';
import 'package:team_play/feature/auth/presentation/screens/login_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseProvider = ref.watch(firebaseLogoutProvider.notifier);
    return Center(
      child: Column(
        children: [
          const Text("bienvenido al home"),
          TextButton(
            onPressed: () {
              firebaseProvider.logout();
              context.go('/login');
              // result.fold(
              //   (error) => {print('Error: $error')},
              //   (logout) => {
              //     print("se deslogeo"),
              //   },
              // );
            },
            child: const Text("logout"),
          ),
        ],
      ),
    );
  }
}
