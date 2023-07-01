import 'package:flutter/material.dart';

class EndTimePicker extends StatelessWidget {
  final Function(BuildContext context) selectTime;
  final TimeOfDay? endTime;

  const EndTimePicker({
    Key? key,
    required this.selectTime,
    required this.endTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Hora de finalización',
          suffixIcon: IconButton(
            icon: const Icon(Icons.access_time),
            onPressed: () {
              selectTime(context);
            },
          ),
        ),
        controller: TextEditingController(
            text: endTime != null ? endTime!.format(context) : ''),
      ),
    );
  }
}
