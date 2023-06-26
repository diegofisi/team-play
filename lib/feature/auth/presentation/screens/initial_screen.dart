import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_uid_provider.dart';
import 'package:team_play/feature/auth/presentation/providers/user_provider.dart';

class InitialScreen extends ConsumerWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(firebaseUIDProvider.notifier).getUid(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasData && snapshot.data != null) {
          return FutureBuilder(
            future: ref
                .watch(isUserRegisteredProvider.notifier)
                .checkUserRegistration(),
            builder: (context, registerSnapshot) {
              if (registerSnapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (registerSnapshot.hasError) {
                return Text('Error: ${registerSnapshot.error}');
              }
              if (registerSnapshot.data == false) {
                Future.microtask(
                  () => context.go('/register'),
                );
                return Container();
              }
              Future.microtask(
                () => context.go('/home/${snapshot.data}'),
              );
              return Container();
            },
          );
        }
        Future.microtask(() => context.go('/login'));
        return Container();
      },
    );
  }
}
