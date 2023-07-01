import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_uid_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.read(firebaseUIDProvider.notifier).getUid();
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            context.go('/home/:$uid');
          },
          child: const Text("back"),
        ),
      ),
    );
  }
}
