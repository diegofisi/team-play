import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:team_play/feature/shared/helpers/form.dart';
import 'package:team_play/feature/auth/infrastructure/models/user_request.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_uid_provider.dart';
import 'package:team_play/feature/auth/presentation/providers/form_provider.dart';
import 'package:team_play/feature/auth/presentation/providers/user_register_provider.dart';
import 'package:team_play/feature/shared/helpers/determine_position.dart';
import 'package:team_play/feature/shared/models/location.dart';
import 'package:team_play/feature/shared/widgets/radius_slider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final buttonKey = GlobalKey();
  late NameInput _name;
  late AgeInput _age;
  late PositionInput _position;
  late RadiusInput _radius;
  bool positionModified = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _name = const NameInput.pure();
    _age = const AgeInput.pure();
    _position = const PositionInput.pure();
    _radius = const RadiusInput.pure();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color.fromARGB(255, 116, 178, 229),
                      Color.fromARGB(255, 6, 60, 104)
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    _buildNameField(),
                    const SizedBox(height: 30),
                    _buildAgeField(),
                    const SizedBox(height: 30),
                    _buildPositionField(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              RadiusSlider(
                radius: _radius,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: ref.watch(isLoadingProvider)
                    ? null
                    : () async {
                        try {
                          ref.read(isLoadingProvider.notifier).state = true;
                          final uid = await ref
                              .read(firebaseUIDProvider.notifier)
                              .getUid();
                          if (_formKey.currentState?.validate() == true) {
                            FirebaseAuth auth = FirebaseAuth.instance;
                            User? userFirebase = auth.currentUser;
                            final location = await determinePosition();
                            final user = UserRequest(
                              age: _age.value,
                              name: _name.value,
                              email: userFirebase?.email ?? "",
                              username:
                                  userFirebase?.displayName ?? _name.value,
                              position:
                                  _position.value.toString().split(".").last,
                              location: Location(
                                  latitude: location.latitude,
                                  longitude: location.longitude),
                            );
                            ref.read(createUserProvider(user).future);
                            ref.read(isLoadingProvider.notifier).state = false;
                            if (context.mounted) {
                              Future.microtask(() => context.go("/home/$uid"));
                            }
                          }
                        } catch (e) {
                          ref.read(isLoadingProvider.notifier).state = false;
                        }
                      },
                child: const Text('Continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        decoration: const InputDecoration(hintText: "Nombre"),
        onChanged: (value) {
          setState(() {
            _name = NameInput.dirty(value);
          });
        },
        validator: (_) {
          if (_name.value.length < 3) {
            return "el nombre debe tener como minimo 3 caracteres";
          }
          if (_name.error != null) {
            return "nombre incorrecto";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildAgeField() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        decoration: const InputDecoration(hintText: 'Edad'),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          setState(() {
            _age = AgeInput.dirty(int.tryParse(value) ?? 0);
          });
        },
        validator: (_) {
          if (_age.value < 12) {
            return "debe ser mayor de 12 años";
          }
          if (_age.error != null) {
            return "edad incorrecta";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPositionField() {
    return Container(
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
        onChanged: (value) {
          positionModified = true;
          setState(() {
            _position = PositionInput.dirty(value as Position);
          });
        },
        validator: (_) {
          if (positionModified == false) {
            return 'Por favor, selecciona una posición';
          }
          if (_position.error != null) {
            return 'La posición no puede estar vacía';
          }
          return null;
        },
      ),
    );
  }
}
