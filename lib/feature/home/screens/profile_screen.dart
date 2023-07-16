import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:team_play/config/helpers/number_formats.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_uid_provider.dart';
import 'package:team_play/feature/home/entities/profile.dart';
import 'package:team_play/feature/home/entities/user_profile.dart';
import 'package:team_play/feature/home/providers/profile_provider.dart';
import 'package:team_play/feature/shared/widgets/comment_form_field.dart';
import 'package:team_play/feature/shared/widgets/user_profile_image.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({required this.id, super.key});
  final String id;

  Future<List> initData(BuildContext context, WidgetRef ref) async {
    final uid = await ref.read(firebaseUIDProvider.notifier).getUid();
    if (uid == null) {
      Future.microtask(() => context.go('/login'));
      return [];
    }
    final profile = await ref.watch(getProfileProvider(id).future);
    final userProfile = await ref.watch(getUserProfileProvider(uid).future);
    return [uid, profile, userProfile];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List>(
      future: initData(context, ref),
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
        final profile = snapshot.data![1] as Profile;
        final userProfile = snapshot.data![2] as UserProfile;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              onPressed: () => context.go('/home/:$uid'),
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text("Profile"),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      id != userProfile.id
                          ? const CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage('assets/images/profile_image.png'),
                              backgroundColor: Colors.transparent,
                            )
                          : const UserProfileImage(),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: SizedBox(
                          width: 35,
                          height: 35,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              HumanFormats.number(profile.rating!, 1),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellowAccent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    profile.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        const Text(
                          "Posicion Preferida",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          profile.position,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (id != userProfile.id)
                    Text(
                      "Escribe a ${profile.name} un comentario",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        wordSpacing: 2.0,
                      ),
                    ),
                  Text(
                    "${profile.name} estos son tus comentarios",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      wordSpacing: 2.0,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: CommentFormField(
                      id: id,
                      otherId: userProfile.id,
                      profile: profile,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
