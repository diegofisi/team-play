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
                        onTap: () {
                          Future.delayed(Duration.zero, () {
                            context.go('/profile');
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
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        return Card(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                    "Partidos a ${snapshot.data.toString()} km de distancia"),
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
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Cargando...");
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    return Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 210,
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 20.0,
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final user = ref.watch(userRepositoryProvider);

                          return GestureDetector(
                            onTap: () async {
                              final id = snapshot.data![index].id;
                              await ref.read(getGameProvider(id).future);
                              if (context.mounted) {
                                Future.microtask(() => context.go('/game/$id'));
                              }
                            },
                            child: SingleChildScrollView(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data![index].title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Fecha: ${DateFormat('yyyy-MM-dd').format(snapshot.data![index].matchDate)}',
                                      ),
                                      Text(
                                          "Hora: ${snapshot.data![index].matchTime}"),
                                      Text(
                                          "se requiere: ${snapshot.data![index].positionNeeded}"),
                                      Text(
                                          "alquiler: S./${snapshot.data![index].fieldRentalPayment}"),
                                      if (snapshot.data![index].createdBy.id ==
                                          user?.id) ...[
                                        Row(
                                          children: [
                                            const Text("Eliminar partido: "),
                                            IconButton(
                                              onPressed: () async {
                                                final id =
                                                    snapshot.data![index].id;
                                                await ref.read(
                                                    deleteGameProvider(id)
                                                        .future);
                                                if (context.mounted) {
                                                  Future.microtask(() =>
                                                      context.go('/games'));
                                                }
                                              },
                                              icon: const Icon(Icons.delete),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
