import 'package:flutter/material.dart';

class NameFormField extends StatelessWidget {
  final TextEditingController controller;

  const NameFormField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(hintText: 'Nombre del Partido'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }
}