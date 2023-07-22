import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_uid_provider.dart';
import 'package:team_play/feature/auth/presentation/providers/user_information_provider.dart';
import 'package:team_play/feature/home/entities/game.dart';
import 'package:team_play/feature/home/entities/user_profile.dart';
import 'package:team_play/feature/home/providers/game_register_provider.dart';
import 'package:team_play/feature/home/providers/profile_provider.dart';
import 'package:team_play/feature/shared/helpers/slider_search.dart';
import 'package:team_play/feature/shared/widgets/custom_button_search.dart';
import 'package:team_play/feature/shared/widgets/user_profile_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GamesScreen extends ConsumerWidget {
  const GamesScreen({super.key});
  Future<List> initData(BuildContext context, WidgetRef ref) async {
    try {
      final uid = await ref.read(firebaseUIDProvider.notifier).getUid();
      if (uid == null) {
        Future.microtask(() => context.go('/login'));
        return [];
      }
      final games = await ref.watch(getGamesProvider.future);
      final userProfile = await ref.watch(getUserProfileProvider(uid).future);
      return [uid, games, userProfile];
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              const Row(
                children: [
                  CustomSearch(
                    heroTag: "buscar_jugador",
                    title: "Buscar Jugador",
                    route: '/game_registration',
                    icon: Icons.person_search,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Column(
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
                  const SizedBox(height: 20),
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
                                    "Partidos a ${snapshot1.data.toString()} km de distancia"),
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
                    final games = snapshot2.data![1] as List<Game>;
                    final userProfile = snapshot2.data![2] as UserProfile;
                    return Expanded(
                      child: MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        itemCount: games.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final id = games[index].id;
                                  await ref.read(getGameProvider(id).future);
                                  if (context.mounted) {
                                    Future.microtask(
                                      () => context.go('/game/$id'),
                                    );
                                  }
                                },
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
                                        Text(
                                          games[index].title,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Fecha: ${DateFormat('yyyy-MM-dd').format(games[index].matchDate)}',
                                        ),
                                        Text("Hora: ${games[index].matchTime}"),
                                        Text(
                                            "se requiere: ${games[index].positionNeeded}"),
                                        Text(
                                            "alquiler: S./${games[index].fieldRentalPayment}"),
                                        if (userProfile.id ==
                                            games[index].createdBy.id)
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
