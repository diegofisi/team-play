import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentFormField extends ConsumerStatefulWidget {
  const CommentFormField({Key? key}) : super(key: key);

  @override
  CommentFormFieldState createState() => CommentFormFieldState();
}

class CommentFormFieldState extends ConsumerState<CommentFormField> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int? selectedRating;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                decoration:
                    const InputDecoration(hintText: 'Escribe un comentario'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un comentario';
                  }
                  return null;
                },
              ),
              DropdownButton<int>(
                hint: Text('Selecciona una clasificación'),
                value: selectedRating,
                items: [1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedRating = newValue;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      selectedRating != null) {
                    // Aquí puedes procesar el comentario y la clasificación
                    // ...
                  }
                  return;
                },
                child: const Text('Enviar comentario'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Recuerda siempre deshacerte de los controladores cuando ya no sean necesarios
    super.dispose();
  }
}
