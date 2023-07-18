import 'package:flutter/material.dart';

class GoalFormField extends StatelessWidget {
  final TextEditingController controller;

  const GoalFormField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: const InputDecoration(hintText: ''),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          if (int.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
      ),
    );
  }
}
