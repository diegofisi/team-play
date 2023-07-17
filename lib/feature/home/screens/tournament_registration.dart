import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_uid_provider.dart';
import 'package:team_play/feature/auth/presentation/providers/form_provider.dart';
import 'package:team_play/feature/home/models/tournament_registration_request.dart';
import 'package:team_play/feature/home/providers/tournament_provider.dart';
import 'package:team_play/feature/shared/models/location.dart';
import 'package:team_play/feature/shared/widgets/form/form.dart';
import 'package:team_play/feature/shared/widgets/custom_map.dart'; // Asegúrate de que la importación es correcta

class TournamentRegistration extends ConsumerStatefulWidget {
  const TournamentRegistration({Key? key}) : super(key: key);

  @override
  TournamentRegistrationState createState() => TournamentRegistrationState();
}

class TournamentRegistrationState
    extends ConsumerState<TournamentRegistration> {
  final _formKey = GlobalKey<FormState>();
  LatLng? tournamentLocation;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  final _prizeController = TextEditingController();
  DateTime? startDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int teamCount = 4;
  int? _position;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _costController.dispose();
    _prizeController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null) {
      setState(() {
        startDate = pickedDate;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        startTime = pickedTime;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        endTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              final uid = ref.read(firebaseUIDProvider.notifier).getUid();
              context.go('/home/$uid');
            },
            child: const Icon(Icons.arrow_back_ios_new_outlined)),
        centerTitle: true,
        title: const Text('Registrar Torneo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 20.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NameFormField(controller: _nameController),

                CostFormField(controller: _costController),
                // Campo de premio
                TextFormField(
                  controller: _prizeController,
                  decoration:
                      const InputDecoration(labelText: 'Premio en soles'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un premio válido';
                    }
                    return null;
                  },
                ),
                StartDatePicker(
                  selectDate: (context) => _selectStartDate(context),
                  startDate: startDate,
                ),
                StartTimePicker(
                  selectTime: (context) => _selectStartTime(context),
                  startTime: startTime,
                ),
                // EndTimePicker(
                //   selectTime: (context) => _selectEndTime(context),
                //   endTime: endTime,
                // ),
                Row(
                  children: [
                    const Text('Cantidad de equipos'),
                    const SizedBox(width: 20.0),
                    NumberPicker(
                      initialValue: _position ?? 4,
                      values: const [4, 8, 16],
                      onChanged: (newPosition) {
                        if (newPosition != null) {
                          setState(() {
                            _position = newPosition;
                          });
                        }
                      },
                    ),
                  ],
                ),
                Center(
                  child: SizedBox(
                    width: size.width * 0.8,
                    height: size.height * 0.25,
                    child: MyMap(
                      onMarkerMoved: (newLocation) {
                        setState(() {
                          tournamentLocation = newLocation;
                        });
                      },
                    ),
                  ),
                ),
                DescriptionFormField(controller: _descriptionController),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: ref.watch(isLoadingProvider)
                          ? null
                          : () async {
                              try {
                                ref.read(isLoadingProvider.notifier).state =
                                    true;
                                final uid = ref
                                    .read(firebaseUIDProvider.notifier)
                                    .getUid();
                                if (_formKey.currentState!.validate() &&
                                    tournamentLocation != null &&
                                    startDate != null &&
                                    startTime != null &&
                                    _position != null &&
                                    _costController.text.isNotEmpty &&
                                    _prizeController.text.isNotEmpty) {
                                  double? cost =
                                      double.tryParse(_costController.text);
                                  int? prize =
                                      int.tryParse(_prizeController.text);
                                  if (cost == null || prize == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Complete todos los campos antes de enviar')),
                                    );
                                    return;
                                  }
                                  final tournament = TournamentRequest(
                                    name: _nameController.text,
                                    date: startDate!,
                                    time:
                                        "${startTime!.hour}:${startTime!.minute}",
                                    inscription: cost.toInt(),
                                    prize: prize,
                                    location: Location(
                                        latitude: tournamentLocation!.latitude,
                                        longitude:
                                            tournamentLocation!.longitude),
                                    teamCount: _position!,
                                  );
                                  await ref.read(
                                      createTournamentProvider(tournament)
                                          .future);
                                  ref.read(isLoadingProvider.notifier).state =
                                      false;
                                  if (context.mounted) {
                                    Future.microtask(
                                        () => context.go("/home/$uid"));
                                  }
                                }
                              } catch (e) {
                                ref.read(isLoadingProvider.notifier).state =
                                    false;
                                return;
                              } finally {
                                ref.read(isLoadingProvider.notifier).state =
                                    false;
                              }
                            },
                      child: const Text('Registrar Torneo'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NumberPicker extends StatelessWidget {
  final int initialValue;
  final List<int> values;
  final Function(int? newValue) onChanged;

  const NumberPicker({
    Key? key,
    required this.initialValue,
    required this.values,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: initialValue,
      items: [
        for (final number in values)
          DropdownMenuItem<int>(
            value: number,
            child: Text('$number'),
          ),
      ],
      onChanged: onChanged,
    );
  }
}
