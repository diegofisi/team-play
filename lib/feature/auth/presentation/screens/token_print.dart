import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_play/feature/auth/domain/repositories/auth_repository_provisional.dart';
import 'package:team_play/feature/auth/infrastructure/datasources/auth_datasource_impl.dart';

class TokenPrint extends StatelessWidget {
  const TokenPrint({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
          onPressed: () {
            getUserId();
          },
          child: Text("conseguir UUID")),
      TextButton(
          onPressed: () {
            PersonFirebase().getPerson();
          },
          child: Text("conseguir usuario")),
    ]);
  }
}

void getUserId() {
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final String? uid = user?.uid;

  print('UID: $uid');
}
