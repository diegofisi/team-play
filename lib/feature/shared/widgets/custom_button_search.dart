import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:team_play/feature/auth/presentation/providers/user_information_provider.dart';

class CustomSearch extends ConsumerWidget {
  final String heroTag;
  final String title;
  final String route;
  final IconData icon;
  const CustomSearch(
      {super.key,
      required this.title,
      required this.route,
      required this.icon,
      required this.heroTag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.extended(
      onPressed: () async {
        final user =
            await ref.read(userRepositoryProvider.notifier).retrieveUser();
        final role = user?.role ?? "user";
        if (route == 'proximo' && role != 'administrador') {
          Future.microtask(
            () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Próximamente'),
                  content: const Text(
                      'Esta característica será implementada próximamente.'),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            ),
          );
          return;
        }
        if (route == 'proximo' && role == 'administrador') {
          return Future.microtask(() => context.go('/tournament_registration'));
        }
        Future.microtask(() => context.go(route));
      },
      hoverColor: Colors.blueGrey,
      label: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      icon: Icon(
        icon,
        size: 20,
      ),
      heroTag: heroTag,
    );
  }
}
