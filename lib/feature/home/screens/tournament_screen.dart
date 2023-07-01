import 'package:flutter/material.dart';

class MyTournamentsScreen extends StatelessWidget {
  const MyTournamentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Torneos'),
      ),
      body: Center(
        child: Text('Página de Mis Torneos'),
      ),
    );
  }
}
