import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_uid_provider.dart';
import 'package:team_play/feature/auth/presentation/providers/form_provider.dart';
import 'package:team_play/feature/home/models/game_request.dart';
import 'package:team_play/feature/home/providers/game_register_provider.dart';
import 'package:team_play/feature/shared/helpers/form.dart';
import 'package:team_play/feature/shared/models/location.dart';
import 'package:team_play/feature/shared/widgets/custom_map.dart';
import 'package:team_play/feature/shared/widgets/form/form.dart';

class GameRegistration extends ConsumerStatefulWidget {
  const GameRegistration({Key? key}) : super(key: key);

  @override
  GameRegistrationState createState() => GameRegistrationState();
}

class GameRegistrationState extends ConsumerState<GameRegistration> {
  final _formKey = GlobalKey<FormState>();
  LatLng? gameLocation;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  Position? _position;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _costController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
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

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          startTime = pickedTime;
        } else {
          endTime = pickedTime;
        }
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
          child: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        centerTitle: true,
        title: const Text('Registrar Partido'),
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
                StartDatePicker(
                  selectDate: (context) => _selectDate(context),
                  startDate: startDate,
                ),
                StartTimePicker(
                  selectTime: (context) => _selectTime(context, true),
                  startTime: startTime,
                ),
                EndTimePicker(
                  selectTime: (context) => _selectTime(context, false),
                  endTime: endTime,
                ),
                Center(
                  child: SizedBox(
                    width: size.width * 0.8,
                    height: size.height * 0.25,
                    child: MyMap(
                      onMarkerMoved: (newLocation) {
                        setState(() {
                          gameLocation = newLocation;
                        });
                      },
                    ),
                  ),
                ),
                PositionField(
                  position: _position,
                  onChanged: (Position? newPosition) {
                    setState(() {
                      _position = newPosition;
                    });
                  },
                ),
                DescriptionFormField(controller: _descriptionController),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: ref.watch(isLoadingProvider)
                          ? null
                          : () {
                              try {
                                ref.read(isLoadingProvider.notifier).state =
                                    true;
                                final uid = ref
                                    .read(firebaseUIDProvider.notifier)
                                    .getUid();
                                if (_formKey.currentState!.validate() &&
                                    gameLocation != null &&
                                    startDate != null &&
                                    startTime != null &&
                                    _position != null &&
                                    startDate != null &&
                                    startTime != null &&
                                    _costController.text.isNotEmpty &&
                                    endTime != null) {
                                  double? cost =
                                      double.tryParse(_costController.text);
                                  if (cost == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Complete all fields before submitting')),
                                    );
                                    return;
                                  }
                                  final game = GameRequest(
                                    positionNeeded: _position!.toShortString(),
                                    matchDate: startDate!,
                                    matchTime:
                                        "${startTime!.hour}:${startTime!.minute} - ${endTime!.hour}:${endTime!.minute}",
                                    fieldRentalPayment: cost,
                                    location: Location(
                                        latitude: gameLocation!.latitude,
                                        longitude: gameLocation!.longitude),
                                    description: _descriptionController.text,
                                  );
                                  ref.read(createGameProvider(game).future);
                                  ref.read(isLoadingProvider.notifier).state =
                                      false;
                                  if (context.mounted) {
                                    Future.microtask(
                                        () => context.go("/home/$uid"));
                                  }
                                }
                              } catch (e) {
                                return;
                              } finally {
                                ref.read(isLoadingProvider.notifier).state =
                                    false;
                              }
                            },
                      child: const Text('Submit'),
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
