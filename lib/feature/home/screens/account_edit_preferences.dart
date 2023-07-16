import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_uid_provider.dart';
import 'package:team_play/feature/home/entities/user_profile.dart';
import 'package:team_play/feature/home/models/profile_update_request.dart';
import 'package:team_play/feature/home/providers/profile_provider.dart';
import 'package:team_play/feature/shared/helpers/form.dart';
import 'package:team_play/feature/shared/widgets/form/edit_age_field.dart';
import 'package:team_play/feature/shared/widgets/form/edit_name_field.dart';
import 'package:team_play/feature/shared/widgets/form/edit_position_field.dart';
import 'package:team_play/feature/shared/widgets/radius_slider.dart';

class AcountEditPreferences extends ConsumerStatefulWidget {
  const AcountEditPreferences({Key? key}) : super(key: key);
  @override
  AcountEditPreferencesState createState() => AcountEditPreferencesState();
}

class AcountEditPreferencesState extends ConsumerState<AcountEditPreferences> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  Position? _selectedPosition;
  Future<List> initData(BuildContext context) async {
    final uid = await ref.read(firebaseUIDProvider.notifier).getUid();
    if (uid == null) {
      Future.microtask(() => context.go('/login'));
      return [];
    }
    final userProfile = await ref.watch(getUserProfileProvider(uid).future);
    return [uid, userProfile];
  }

  late RadiusInput _radius;

  @override
  void initState() {
    super.initState();
    _radius = const RadiusInput.pure();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.deepPurple[800],
    );

    return FutureBuilder(
      future: initData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final uid = snapshot.data![0] as String;
        final userProfile = snapshot.data![1] as UserProfile;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              onPressed: () => context.go('/home/:$uid'),
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text("Edit Preferences"),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Nombre actual: ${userProfile.name}",
                    style: textStyle,
                  ),
                  NameFormFieldEdit(
                      controller: _nameController, hintText: "Nombre"),
                  const SizedBox(height: 20.0),
                  Text(
                    "Username actual: ${userProfile.username}",
                    style: textStyle,
                  ),
                  NameFormFieldEdit(
                      controller: _userNameController, hintText: "UserName"),
                  const SizedBox(height: 20.0),
                  Text(
                    "Posicion actual: ${userProfile.position}",
                    style: textStyle,
                  ),
                  PositionFieldEdit(
                    position: _selectedPosition,
                    onChanged: (Position? newPosition) {
                      _selectedPosition = newPosition;
                    },
                  ),
                  Text(
                    "Edad actual: ${userProfile.age}",
                    style: textStyle,
                  ),
                  AgeFieldEdit(controller: _ageController),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final ProfileUpdateRequest profileUpdateRequest =
                            ProfileUpdateRequest(
                          name: _nameController.text.isNotEmpty
                              ? _nameController.text
                              : userProfile.name,
                          position: _selectedPosition?.toShortString() ??
                              userProfile.position,
                          age: _ageController.text.isNotEmpty
                              ? int.parse(_ageController.text)
                              : userProfile.age,
                          username: _userNameController.text.isNotEmpty
                              ? _userNameController.text
                              : userProfile.username,
                        );
                        await ref.read(profileUpdateProvider(
                                tuple2(userProfile.id, profileUpdateRequest))
                            .future);

                        Future.microtask(() => context.go('/home/:$uid'));
                      }
                    },
                    child: const Text('Update Profile'),
                  ),
                  RadiusSlider(radius: _radius),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
