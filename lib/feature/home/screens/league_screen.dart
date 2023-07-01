import 'package:flutter/material.dart';

class LeaguesScreen extends StatelessWidget {
  const LeaguesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ligas'),
      ),
      body: Center(
        child: Text('Página de Ligas'),
      ),
    );
  }
}