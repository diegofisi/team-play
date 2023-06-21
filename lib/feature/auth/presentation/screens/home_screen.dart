import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:team_play/feature/auth/domain/repositories/auth_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: TextButton(
            onPressed: () {
              AuthService().signOut();
            },
            child: Text("logout")),
      ),
      Container(
        child: TextButton(
            onPressed: () async {
              String firebaseIdToken =
                  await FirebaseAuth.instance.currentUser?.getIdToken() ??
                      "no token";
              while (firebaseIdToken.length > 0) {
                int startTokenLength = (firebaseIdToken.length >= 500
                    ? 500
                    : firebaseIdToken.length);
                print("TokenPart: " +
                    firebaseIdToken.substring(0, startTokenLength));
                int lastTokenLength = firebaseIdToken.length;
                firebaseIdToken = firebaseIdToken.substring(
                    startTokenLength, lastTokenLength);
              }
            },
            child: Text("get token")),
      )
    ]);
  }
}
