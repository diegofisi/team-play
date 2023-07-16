import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:team_play/feature/auth/presentation/providers/user_information_provider.dart';
import 'package:team_play/feature/home/entities/game.dart';
import 'package:team_play/feature/home/providers/game_register_provider.dart';
import 'package:team_play/feature/shared/helpers/slider_search.dart';
import 'package:team_play/feature/shared/widgets/custom_button_search.dart';
import 'package:team_play/feature/shared/widgets/user_profile_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GamesScreen extends ConsumerWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(getGamesProvider.future);
    return Center(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              const Row(
                children: [
                  Expanded(
                    child: CustomSearch(
                      heroTag: "torneo1",
                      title: "Mi Torneo",
                      route: 'proximo',
                      icon: Icons.travel_explore_rounded,
                    ),
                  ),
                  SizedBox(width: 40),
                  Expanded(
                    child: CustomSearch(
                      heroTag: "buscar_jugador",
                      title: "Buscar Jugador",
                      route: '/game_registration',
                      icon: Icons.person_search,
                    ),
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
                          print("user id: " + user!.id);
                          Future.delayed(Duration.zero, () {
                            Future.microtask(
                                () => context.go('/profile/${user.id}'));
                          });
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
              FutureBuilder<List<Game>>(
                future: games,
                builder: (BuildContext context, snapshot2) {
                  if (snapshot2.connectionState == ConnectionState.waiting) {
                    return const Text("Cargando...");
                  }
                  if (snapshot2.hasError) {
                    return Text('Error: ${snapshot2.error}');
                  }
                  if (snapshot2.hasData) {
                    return Expanded(
                      child: MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        itemCount: snapshot2.data!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final id = snapshot2.data![index].id;
                                  await ref.read(getGameProvider(id).future);
                                  if (context.mounted) {
                                    Future.microtask(
                                        () => context.go('/game/$id'));
                                  }
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot2.data![index].title,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Fecha: ${DateFormat('yyyy-MM-dd').format(snapshot2.data![index].matchDate)}',
                                        ),
                                        Text(
                                            "Hora: ${snapshot2.data![index].matchTime}"),
                                        Text(
                                            "se requiere: ${snapshot2.data![index].positionNeeded}"),
                                        Text(
                                            "alquiler: S./${snapshot2.data![index].fieldRentalPayment}"),
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
