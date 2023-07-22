import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_uid_provider.dart';
import 'package:team_play/feature/home/entities/tournament.dart';
import 'package:team_play/feature/home/entities/user_profile.dart';
import 'package:team_play/feature/home/providers/profile_provider.dart';
import 'package:team_play/feature/home/providers/tournament_provider.dart';

class TournamentScreen extends ConsumerWidget {
  final String tournamentId;
  const TournamentScreen({required this.tournamentId, super.key});

  Future<List> initData(BuildContext context, WidgetRef ref) async {
    try {
      final uid = await ref.read(firebaseUIDProvider.notifier).getUid();
      if (uid == null) {
        Future.microtask(() => context.go('/login'));
        return [];
      }
      final tournament =
          await ref.watch(getTournamentProvider(tournamentId).future);
      final userProfile = await ref.watch(getUserProfileProvider(uid).future);
      return [uid, tournament, userProfile];
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
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
        final tournament = snapshot.data![1] as Tournament;
        final userProfile = snapshot.data![2] as UserProfile;

        final count = tournament.teams
            .where(
                (team) => team.state == 'pendiente' || team.state == 'aceptado')
            .length;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () async {
                Future.microtask(() => context.go('/home/:$uid'));
              },
              icon: const Icon(Icons.arrow_back),
            ),
            centerTitle: true,
            title: Text(
              tournament.name,
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomField(
                    field: tournament.time,
                    text: "Hora",
                    size: size,
                    tournament: tournament,
                  ),
                  const SizedBox(height: 10),
                  CustomField(
                    field:
                        '${tournament.date.year}-${tournament.date.month}-${tournament.date.day}',
                    text: "Fecha",
                    size: size,
                    tournament: tournament,
                  ),
                  CustomField(
                    field: "S./${tournament.inscription}",
                    text: "Inscripcion",
                    size: size,
                    tournament: tournament,
                  ),
                  CustomField(
                    field: "S./${tournament.prize}",
                    text: "Premio",
                    size: size,
                    tournament: tournament,
                  ),
                  CustomField(
                    field: tournament.teamCount.toString(),
                    text: "Jugadores max",
                    size: size,
                    tournament: tournament,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Ubicacion",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: size.width * 0.8,
                    height: size.height * 0.25,
                    child: FlutterMap(
                      options: MapOptions(
                        center: LatLng(
                          tournament.location.latitude,
                          tournament.location.longitude,
                        ),
                        zoom: 14.5,
                        maxZoom: 18.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 80.0,
                              height: 80.0,
                              point: LatLng(
                                tournament.location.latitude,
                                tournament.location.longitude,
                              ),
                              builder: (ctx) => const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  if (tournament.createdBy == userProfile.id)
                    const Text(
                      "eres el creador del torneo",
                      style: TextStyle(overflow: TextOverflow.clip),
                    ),
                  GestureDetector(
                    onTap: () async {
                      final id = tournament.createdBy;
                      Future.delayed(
                        Duration.zero,
                        () {
                          Future.microtask(() => context.go('/profile/$id'));
                        },
                      );
                    },
                    child: const Column(
                      children: [
                        SizedBox(height: 10),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage('assets/images/profile_image.png'),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "perfil del creador del torneo",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // if (tournament.createdBy != userProfile.id &&
                  //     tournament.playerInterested == null)
                  //   ElevatedButton(
                  //     onPressed: () async {
                  //       final gameRegister = tuple2(game.id, userProfile.id);
                  //       await ref.read(registerGameProvider(gameRegister).future);
                  //       Future.microtask(
                  //         () => ScaffoldMessenger.of(context).showSnackBar(
                  //           const SnackBar(
                  //             content: Text("Te has registrado al partido"),
                  //           ),
                  //         ),
                  //       );
                  //       Future.microtask(() => context.go('/home/:$uid'));
                  //     },
                  //     child: const Text("Registrarse al partido"),
                  //   ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (context.mounted) {
                            Future.microtask(
                              () => context
                                  .go('/tournament_branches/$tournamentId'),
                            );
                          }
                        },
                        child: const Text("Ver torneo"),
                      ),
                      if (tournament.createdBy == userProfile.id)
                        ElevatedButton(
                          onPressed: () {
                            context.go('/tournament_management/$tournamentId');
                          },
                          child: const Text("Gestionar Torneo"),
                        ),
                      if (tournament.teamCount > count)
                        ElevatedButton(
                          onPressed: () {
                            context.go(
                                '/tournament_team_registration/$tournamentId');
                          },
                          child: const Text("registrarse"),
                        ),
                      if (tournament.teamCount <= count)
                        const ElevatedButton(
                          onPressed: null,
                          child: Text("registrarse"),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (tournament.createdBy == userProfile.id)
                    GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Eliminar torneo: "),
                          IconButton(
                            onPressed: () async {
                              await ref.read(
                                  deleteTournamentProvider(tournamentId)
                                      .future);
                              if (context.mounted) {
                                Future.microtask(
                                  () => ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text("Partido eliminado"),
                                    ),
                                  ),
                                );
                                Future.microtask(
                                  () => context.go('/home/:$uid'),
                                );
                              }
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomField extends StatelessWidget {
  final String field;
  final String text;
  const CustomField({
    super.key,
    required this.size,
    required this.tournament,
    required this.field,
    required this.text,
  });

  final Size size;
  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.deepPurpleAccent,
            ),
          ),
          Text(
            field,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
