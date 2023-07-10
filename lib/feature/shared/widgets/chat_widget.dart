import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatRedirectButton extends StatelessWidget {
  final String chatId;

  const ChatRedirectButton({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () {
          Future.delayed(Duration.zero, () {
            context.go('/chat/:$chatId');
          });
        },
        icon: const Icon(Icons.chat),
        label: const Text('Iniciar chat'),
      ),
    );
  }
}
