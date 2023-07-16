import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = buildSettings(context);
    return Center(
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: settings.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(settings[index].title),
            onTap: () => settings[index].onTap(),
          );
        },
      ),
    );
  }
}

class Settings {
  final String title;
  final IconData icon;
  final Function onTap;

  const Settings(
      {required this.title, required this.icon, required this.onTap});
}

List<Settings> buildSettings(BuildContext context) {
  GoogleSignIn googleSignIn = GoogleSignIn();

  return [
    Settings(
      title: "Preferencias de cuenta",
      icon: Icons.account_circle,
      onTap: () {
        context.go('/account_edit_preferences');
      },
    ),
    Settings(
      title: "Notificaciones",
      icon: Icons.notifications,
      onTap: () {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('Notificaciones'),
              content: const Text('Proximamente'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    ),
    Settings(
      title: "Acerca de",
      icon: Icons.security,
      onTap: () {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('Acerca de'),
              content: const Text('Proximamente'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    ),
    Settings(
      title: "Valoranos",
      icon: Icons.help,
      onTap: () {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('Valoranos'),
              content: const Text('Proximamente'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    ),
    Settings(
      title: "Privacidad",
      icon: Icons.info,
      onTap: () {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('Privacidad'),
              content: const Text('Proximamente'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    ),
    Settings(
      title: "¿Eres empresa?",
      icon: Icons.article,
      onTap: () {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('¿Eres empresa?'),
              content: const Text('Proximamente'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    ),
    Settings(
      title: "Licencias",
      icon: Icons.open_in_new,
      onTap: () {
        return showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return const AboutDialog(
              applicationName: 'Licencias',
              applicationVersion: '1.0.0',
              applicationIcon: Icon(Icons.open_in_new),
              applicationLegalese: 'Proximamente',
            );
          },
        );
      },
    ),
    Settings(
      title: "Logout",
      icon: Icons.logout,
      onTap: () async {
        try {
          if (await googleSignIn.isSignedIn()) {
            await googleSignIn.disconnect();
          }
          await FirebaseAuth.instance.signOut();
          Future.microtask(() => context.go('/login'));
        } catch (e) {
          print('Error: $e');
        }
      },
    ),
  ];
}
