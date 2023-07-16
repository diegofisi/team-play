import 'package:flutter/material.dart';
import 'package:team_play/feature/shared/helpers/form.dart';

class PositionFieldEdit extends StatelessWidget {
  final Position? position;
  final Function(Position?) onChanged;

  const PositionFieldEdit({
    Key? key,
    required this.position,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButtonFormField(
          decoration: const InputDecoration(hintText: 'Posición'),
          items: Position.values
              .map((position) => DropdownMenuItem(
                    value: position,
                    child: Text(position.toShortString()),
                  ))
              .toList(),
          value: position,
          onChanged: onChanged,
          validator: (_) {
            if (position == null) {
              return null;
            }
            return null;
          },
        ),
      ),
    );
  }
}
