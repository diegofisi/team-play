import 'package:flutter/material.dart';

class StartTimePicker extends StatelessWidget {
  final Function(BuildContext context) selectTime;
  final TimeOfDay? startTime;

  const StartTimePicker({
    Key? key,
    required this.selectTime,
    required this.startTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Hora de inicio',
          suffixIcon: IconButton(
            icon: const Icon(Icons.access_time),
            onPressed: () {
              selectTime(context);
            },
          ),
        ),
        controller: TextEditingController(
            text: startTime != null ? startTime!.format(context) : ''),
      ),
    );
  }
}
