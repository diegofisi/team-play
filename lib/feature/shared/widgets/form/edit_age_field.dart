import 'package:flutter/material.dart';

class AgeFieldEdit extends StatelessWidget {
  final TextEditingController controller;

  const AgeFieldEdit({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(hintText: 'Edad'),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return null;
        }
        if (int.parse(value) < 12) {
          return "debe ser mayor de 12 años";
        }
        return null;
      },
    );
  }
}
