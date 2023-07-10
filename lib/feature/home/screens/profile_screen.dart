import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_logout_provider.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_uid_provider.dart';
import 'package:team_play/feature/home/entities/user_profile.dart';
import 'package:team_play/feature/home/providers/profile_provider.dart';
import 'package:team_play/feature/shared/widgets/comment_form_field.dart';
import 'package:team_play/feature/shared/widgets/user_profile_image.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uidProvider = ref.read(firebaseUIDProvider.notifier).getUid();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () async {
            final uid = await uidProvider;
            Future.microtask(() => context.go('/home/:$uid'));
          },
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
                  const UserProfileImage(),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: SizedBox(
                      width: 35,
                      height: 35,
                      child: FutureBuilder<String?>(
                        future: uidProvider,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final uidProvider = snapshot.data!;
                            final profile = ref.read(
                                getUserProfileProvider(uidProvider).future);
                            return FutureBuilder<UserProfile>(
                              future: profile,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final profileId = snapshot.data!.id;
                                  final profile = ref.read(
                                      getProfileProvider(profileId).future);
                                  return FutureBuilder(
                                    future: profile,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final profileRating =
                                            snapshot.data!.rating;
                                        return Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Text(
                                            profileRating.toString(),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.yellowAccent,
                                            ),
                                          ),
                                        );
                                      }
                                      return const Center(
                                        child: SizedBox(),
                                      );
                                    },
                                  );
                                }
                                return const Center(
                                  child: SizedBox(),
                                );
                              },
                            );
                          }
                          return const Center(
                            child: SizedBox(),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
              FutureBuilder(
                future: uidProvider,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return FutureBuilder(
                      future: ref
                          .read(getUserProfileProvider(snapshot.data!).future),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                snapshot.data!.name,
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
                                      snapshot.data!.position,
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
                              Text(
                                "Escribe a ${snapshot.data!.name} un comentario",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  wordSpacing: 2.0,
                                ),
                              )
                            ],
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: SizedBox(),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.25,
                child: FutureBuilder<String?>(
                  future: uidProvider,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final uidProvider = snapshot.data!;
                      final profile =
                          ref.read(getUserProfileProvider(uidProvider).future);
                      return FutureBuilder<UserProfile>(
                        future: profile,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final profileId = snapshot.data!.id;
                            final profile =
                                ref.read(getProfileProvider(profileId).future);
                            return FutureBuilder(
                              future: profile,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final profileComments =
                                      snapshot.data!.comments;
                                  if (profileComments.isEmpty) {
                                    return const Center(
                                      child: Text("No hay comentarios"),
                                    );
                                  } else {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 13,
                                          ),
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: BorderSide(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              width: 1,
                                            ),
                                          ),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              child: Text(profileComments[index]
                                                  .rating
                                                  .toString()),
                                            ),
                                            title: Text(
                                              profileComments[index].comment,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: profileComments.length,
                                    );
                                  }
                                }
                                return const Center(
                                  child: SizedBox(),
                                );
                              },
                            );
                          }
                          return const Center(
                            child: SizedBox(),
                          );
                        },
                      );
                    }
                    return const Center(
                      child: SizedBox(),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder<String?>(
                future: uidProvider,
                builder: (context, snapshot1) {
                  if (snapshot1.hasData) {
                    final uidProvider = snapshot1.data!;
                    final profile =
                        ref.read(getUserProfileProvider(uidProvider).future);
                    return FutureBuilder<UserProfile>(
                      future: profile,
                      builder: (context, snapshot2) {
                        if (snapshot2.hasData) {
                          if (snapshot1.data!.toString() !=
                              snapshot2.data!.uid.toString()) {
                            return const CommentFormField();
                          }
                        }
                        return const Center(
                          child: SizedBox(),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: SizedBox(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
