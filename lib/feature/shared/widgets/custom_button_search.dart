import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomSearch extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        if (route == 'proximo') {
          showDialog(
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
          );
          return;
        }

        context.go(route);
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
