import 'package:flutter/material.dart';

class DescriptionFormField extends StatelessWidget {
  final TextEditingController controller;

  const DescriptionFormField({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: TextFormField(
        controller: controller,
        decoration: const InputDecoration(hintText: 'Descripcion'),
        validator: (value) {
          return null;
        },
      ),
    );
  }
}
