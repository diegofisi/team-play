import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_uid_provider.dart';
import 'package:team_play/feature/auth/presentation/providers/user_information_provider.dart';
import 'package:team_play/feature/home/entities/tournament.dart';
import 'package:team_play/feature/home/entities/user_profile.dart';
import 'package:team_play/feature/home/providers/profile_provider.dart';
import 'package:team_play/feature/home/providers/tournament_provider.dart';
import 'package:team_play/feature/shared/helpers/slider_search.dart';
import 'package:team_play/feature/shared/widgets/custom_button_search.dart';
import 'package:team_play/feature/shared/widgets/user_profile_image.dart';

class MyTournaments extends ConsumerWidget {
  const MyTournaments({super.key});

  Future<List> initData(BuildContext context, WidgetRef ref) async {
    try {
      final uid = await ref.read(firebaseUIDProvider.notifier).getUid();
      if (uid == null) {
        Future.microtask(() => context.go('/login'));
        return [];
      }
      final tournaments = await ref.watch(getTournamentsProvider.future);
      final userProfile = await ref.watch(getUserProfileProvider(uid).future);
      return [uid, tournaments, userProfile];
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              const Row(
                children: [
                  CustomSearch(
                    heroTag: "torneo1",
                    title: "Crear torneo",
                    route: 'proximo',
                    icon: Icons.travel_explore_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const SizedBox(width: 30),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final user = await ref
                              .read(userRepositoryProvider.notifier)
                              .retrieveUser();
                          Future.delayed(
                            Duration.zero,
                            () {
                              Future.microtask(
                                  () => context.go('/profile/${user!.id}'));
                            },
                          );
                        },
                        child: const UserProfileImage(),
                      ),
                      const SizedBox(height: 10),
                      const Text("Mi Perfil"),
                    ],
                  ),
                  const Spacer(),
                  FutureBuilder(
                    future: getRadiusValue(),
                    builder: (BuildContext context, snapshot1) {
                      if (snapshot1.hasData) {
                        return Card(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                    "Torneos a ${snapshot1.data.toString()} km de distancia"),
                              ],
                            ),
                          ),
                        );
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              FutureBuilder<List>(
                future: initData(context, ref),
                builder: (BuildContext context, snapshot2) {
                  if (snapshot2.connectionState == ConnectionState.waiting) {
                    return const Text("Cargando...");
                  }
                  if (snapshot2.hasError) {
                    return Text('Error: ${snapshot2.error}');
                  }
                  if (snapshot2.hasData) {
                    final tournament = snapshot2.data![1] as List<Tournament>;
                    final userProfile = snapshot2.data![2] as UserProfile;
                    return Expanded(
                      child: MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        itemCount: tournament.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final id = tournament[index].id;
                                  await ref
                                      .read(getTournamentProvider(id).future);
                                  if (context.mounted) {
                                    Future.microtask(
                                      () => context.go('/tournament/$id'),
                                    );
                                  }
                                },
                                child: SizedBox(
                                  width: size.width * 0.4,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              tournament[index].name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Text(
                                            'Fecha: ${tournament[index].date.year}-${tournament[index].date.month}-${tournament[index].date.day}',
                                          ),
                                          Text(
                                            'Hora: ${tournament[index].time}',
                                          ),
                                          Text(
                                            "Inscripcion: S./${tournament[index].inscription}",
                                          ),
                                          Text(
                                            "Premio: S./${tournament[index].prize}",
                                          ),
                                          Text(
                                            "Jugadores max: ${tournament[index].teamCount}",
                                          ),
                                          if (userProfile.id ==
                                              tournament[index].createdBy)
                                            const Text(
                                              "Owner",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }

                  return const Text(
                      'No hay ningun partido disponible por tu zona');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
