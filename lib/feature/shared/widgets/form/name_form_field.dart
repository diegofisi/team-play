import 'package:flutter/material.dart';

class NameFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;

  const NameFormField({Key? key, required this.controller, this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText ?? 'Nombre del Partido'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }
}
