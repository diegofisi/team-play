import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/auth/domain/repositories/provisional.dart';

class TokenPrint extends ConsumerWidget {
  const TokenPrint({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      TextButton(
        onPressed: () async {},
        child: Text("test"),
      ),
      TextButton(
          onPressed: () {
            AuthService().signInWithGoogle();
          },
          child: const Text("Login")),
      TextButton(
        onPressed: () {
          AuthService().signOut();
        },
        child: Text("logout"),
      ),
      TextButton(
        onPressed: () async {
          String firebaseIdToken =
              await FirebaseAuth.instance.currentUser?.getIdToken() ??
                  "no token";
          while (firebaseIdToken.isNotEmpty) {
            int startTokenLength =
                (firebaseIdToken.length >= 500 ? 500 : firebaseIdToken.length);
            print(
                "TokenPart: " + firebaseIdToken.substring(0, startTokenLength));
            int lastTokenLength = firebaseIdToken.length;
            firebaseIdToken =
                firebaseIdToken.substring(startTokenLength, lastTokenLength);
          }
        },
        child: const Text("get token"),
      ),
      TextButton(
          onPressed: () async {
            FirebaseAuth auth = FirebaseAuth.instance;
            final User? user = auth.currentUser;
            final String? uid = user?.uid;
            print('UID: $uid');
          },
          child: Text("conseguir UUID")),
    ]);
  }
}

void getUserId() {
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final String? uid = user?.uid;

  print('UID: $uid');
}
