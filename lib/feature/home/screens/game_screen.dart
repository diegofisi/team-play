import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_uid_provider.dart';
import 'package:team_play/feature/auth/presentation/providers/user_information_provider.dart';
import 'package:team_play/feature/home/providers/game_register_provider.dart';
import 'package:team_play/feature/home/providers/profile_provider.dart';
import 'package:team_play/feature/shared/widgets/chat_widget.dart';

class GameScreen extends ConsumerWidget {
  final String gameID;

  const GameScreen(this.gameID, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return FutureBuilder(
        future: ref.read(getGameProvider(gameID).future),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () async {
                    final uid =
                        await ref.read(firebaseUIDProvider.notifier).getUid();
                    Future.microtask(() => context.go('/home/:$uid'));
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                centerTitle: true,
                title: Text(snapshot.data!.title),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Hora: ${snapshot.data!.matchTime} ",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Fecha: ${snapshot.data!.matchDate.day}/${snapshot.data!.matchDate.month}/${snapshot.data!.matchDate.year} ",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(snapshot.data!.description),
                    const Text("Recuerda que: "),
                    Text(
                        "Pago por alquiler: S./${snapshot.data!.fieldRentalPayment}"),
                    const SizedBox(height: 20),
                    const Text("Ubicacion"),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: size.width * 0.8,
                      height: size.height * 0.25,
                      child: FlutterMap(
                        options: MapOptions(
                          center: LatLng(
                            snapshot.data!.location.latitude,
                            snapshot.data!.location.longitude,
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
                                  snapshot.data!.location.latitude,
                                  snapshot.data!.location.longitude,
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
                    if (snapshot.data!.description != '')
                      const Text("Comentarios: "),
                    Text(snapshot.data!.description),
                    const Text(
                      'Alguna otra duda? Chatea con el creador la solicitud',
                      style: TextStyle(overflow: TextOverflow.clip),
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder(
                      future: ref.read(firebaseUIDProvider.notifier).getUid(),
                      builder: (context, snapshot1) {
                        if (snapshot1.hasData) {
                          final game = ref.read(getGameProvider(gameID).future);
                          return FutureBuilder(
                            future: game,
                            builder: (context, snapshot2) {
                              if (snapshot2.hasData) {
                                final userProfile = ref.read(
                                    getUserProfileProvider(snapshot1.data!)
                                        .future);
                                return FutureBuilder(
                                  future: userProfile,
                                  builder: (context, snapshot3) {
                                    if (snapshot3.hasData) {
                                      if (snapshot3.data!.id !=
                                          snapshot2.data!.createdBy.id) {
                                        return ChatRedirectButton(
                                          chatId: snapshot2.data!.createdBy.id,
                                        );
                                      }
                                      return Container();
                                    }
                                    return Container();
                                  },
                                );
                              }
                              return Container();
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
