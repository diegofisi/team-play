import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                          //TODO: implementar la navegacion al perfil
                        },
                        child: const UserProfileImage(),
                      ),
                      const SizedBox(height: 10),
                      const Text("Mi Perfil"),
                    ],
                  ),
                  //rellena con un espacio en blanco que ocupa todo el espacio posible
                  const Spacer(),

                  FutureBuilder(
                    future: getRadiusValue(),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<int> snapshot,
                    ) {
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
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
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
                    return TextButton(
                      onPressed: () {
                        print(snapshot
                            .data); // Esto imprimirá los datos en la consola
                      },
                      child:
                          Text('Partidos cargados: ${snapshot.data!.length}'),
                    );
                  }
                  return Text('Aún no hay datos');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
