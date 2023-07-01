import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfileImage extends StatelessWidget {
  const UserProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && user.photoURL != null) {
      return CircleAvatar(
        radius: 50, // puedes ajustar el radio para cambiar el tamaño del círculo
        backgroundImage: NetworkImage(user.photoURL!),
        backgroundColor: Colors.transparent, // esto es opcional, en caso de que quieras un fondo diferente
      );
    } else {
      return const CircleAvatar(
        radius: 50,
        backgroundColor: Colors.transparent, // esto es opcional, en caso de que quieras un fondo diferente
        child: Icon(Icons.account_circle),
      );
    }
  }
}