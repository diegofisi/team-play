import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_uid_provider.dart';
import 'package:team_play/feature/home/entities/game.dart';
import 'package:team_play/feature/home/entities/user_profile.dart';
import 'package:team_play/feature/home/providers/game_register_provider.dart';
import 'package:team_play/feature/home/providers/profile_provider.dart';
import 'package:team_play/feature/shared/widgets/chat_widget.dart';

class GameScreen extends ConsumerWidget {
  final String gameID;
  const GameScreen(this.gameID, {super.key});

  Future<List> initData(BuildContext context, WidgetRef ref) async {
    final uid = await ref.read(firebaseUIDProvider.notifier).getUid();
    if (uid == null) {
      Future.microtask(() => context.go('/login'));
      return [];
    }
    final game = await ref.watch(getGameProvider(gameID).future);
    final userProfile = await ref.watch(getUserProfileProvider(uid).future);
    return [uid, game, userProfile];
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
        final game = snapshot.data![1] as Game;
        final userProfile = snapshot.data![2] as UserProfile;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () async {
                Future.microtask(() => context.go('/home/:$uid'));
              },
              icon: const Icon(Icons.arrow_back),
            ),
            centerTitle: true,
            title: Text(game.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Hora: ${game.matchTime} ",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  "Fecha: ${game.matchDate.day}/${game.matchDate.month}/${game.matchDate.year} ",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(game.description),
                const Text("Recuerda que: "),
                Text("Pago por alquiler: S./${game.fieldRentalPayment}"),
                const SizedBox(height: 20),
                const Text("Ubicacion"),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.8,
                  height: size.height * 0.25,
                  child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(
                        game.location.latitude,
                        game.location.longitude,
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
                              game.location.latitude,
                              game.location.longitude,
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
                const SizedBox(height: 20),
                if (game.description != '') const Text("Comentarios: "),
                Text(game.description),
                const Text(
                  'Alguna otra duda? Chatea con el creador la solicitud',
                  style: TextStyle(overflow: TextOverflow.clip),
                ),
                GestureDetector(
                  onTap: () async {
                    final id = game.createdBy.id;
                    Future.delayed(
                      Duration.zero,
                      () {
                        Future.microtask(() => context.go('/profile/$id'));
                      },
                    );
                  },
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const SizedBox(
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('assets/images/profile_image.png'),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      Text(game.createdBy.username),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (game.createdBy.id == userProfile.id)
                  const Text("Eres el creador del partido"),
                if (game.createdBy.id != userProfile.id &&
                    game.playerInterested == null)
                  ElevatedButton(
                    onPressed: () async {
                      final gameRegister = tuple2(game.id, userProfile.id);
                      await ref.read(registerGameProvider(gameRegister).future);
                      Future.microtask(
                        () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Te has registrado al partido"),
                          ),
                        ),
                      );
                      Future.microtask(() => context.go('/home/:$uid'));
                    },
                    child: const Text("Registrarse al partido"),
                  ),
                if (game.playerInterested != null &&
                    game.createdBy.id == userProfile.id)
                  const Column(
                    children: [
                      Text("Chatea con el jugador interesado)"),
                    ],
                  ),
                if (game.createdBy.id != userProfile.id &&
                    game.playerInterested != null)
                  ChatRedirectButton(chatId: game.createdBy.id),
                if (game.createdBy.id == userProfile.id &&
                    game.playerInterested != null)
                  ChatRedirectButton(chatId: game.playerInterested!)
              ],
            ),
          ),
        );
      },
    );
  }
}
