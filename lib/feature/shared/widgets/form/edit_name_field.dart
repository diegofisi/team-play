import 'package:flutter/material.dart';

class NameFormFieldEdit extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;

  const NameFormFieldEdit({Key? key, required this.controller, this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText ?? 'Nombre del Partido'),
      validator: (value) {
        return null;
      },
    );
  }
}
