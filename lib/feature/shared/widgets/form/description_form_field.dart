import 'package:flutter/material.dart';

class DescriptionFormField extends StatelessWidget {
  final TextEditingController controller;

  const DescriptionFormField({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: TextFormField(
        controller: controller,
        decoration: const InputDecoration(hintText: 'Descripcion'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      ),
    );
  }
}