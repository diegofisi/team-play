import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StartDatePicker extends StatelessWidget {
  final Function(BuildContext context) selectDate;
  final DateTime? startDate;

  const StartDatePicker({
    Key? key,
    required this.selectDate,
    required this.startDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Fecha de inicio',
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              selectDate(context);
            },
          ),
        ),
        controller: TextEditingController(
            text: startDate != null
                ? DateFormat('yyyy-MM-dd').format(startDate!)
                : ''),
      ),
    );
  }
}