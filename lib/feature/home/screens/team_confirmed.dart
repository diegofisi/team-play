import 'dart:convert';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_uid_provider.dart';
import 'package:team_play/feature/home/entities/tournament.dart';
import 'package:team_play/feature/home/models/accept_team_request.dart';
import 'package:team_play/feature/home/models/reject_team_request.dart';
import 'package:team_play/feature/home/providers/profile_provider.dart';
import 'package:team_play/feature/home/providers/tournament_provider.dart';

class TeamConfirmed extends ConsumerStatefulWidget {
  final String id;

  const TeamConfirmed({required this.id, super.key});

  @override
  TeamConfirmedState createState() => TeamConfirmedState();
}

class TeamConfirmedState extends ConsumerState<TeamConfirmed> {
  Map<String, String> teamStatuses = {};

  Future<List> initData(BuildContext context, WidgetRef ref) async {
    try {
      final uid = await ref.read(firebaseUIDProvider.notifier).getUid();
      if (uid == null) {
        Future.microtask(() => context.go('/login'));
        return [];
      }
      final tournament =
          await ref.watch(getTournamentProvider(widget.id).future);
      final userProfile = await ref.watch(getUserProfileProvider(uid).future);

      for (var team in tournament.teams) {
        teamStatuses[team.id] = team.state;
      }
      return [uid, tournament, userProfile];
    } catch (e) {
      return [];
    }
  }

  Future<Uint8List?> _decodeImage(String base64) async {
    try {
      Uint8List data = base64Decode(base64);
      var result = await FlutterImageCompress.compressWithList(
        data,
        minHeight: 250,
        minWidth: 250,
        quality: 80,
      );
      return result;
    } catch (e) {
      return null;
    }
  }

  String getTeamState(String teamId) {
    return teamStatuses[teamId] ?? 'pendiente';
  }

  void setTeamState(String teamId, String newState) {
    setState(() {
      teamStatuses[teamId] = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
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

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              onPressed: () => context.go('/home/:$uid'),
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text("Teams Manager"),
          ),
          body: Center(
            child: SizedBox(
              width: size.width * 0.85,
              child: ListView.builder(
                itemCount: tournament.teams.length,
                itemBuilder: (context, index) {
                  var team = tournament.teams[index];
                  return FutureBuilder(
                    future: _decodeImage(team.voucher),
                    builder: (context, snapshot) {
                      Image? image;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasData && snapshot.data != null) {
                        image = Image.memory(snapshot.data as Uint8List);
                      } else {
                        image = Image.asset('assets/images/profile_image.png');
                      }

                      return Card(
                        key: Key(team.id),
                        margin: const EdgeInsets.all(8),
                        elevation: 4,
                        child: ListTile(
                          leading: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.8,
                                      child: image,
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text("Cerrar"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: image,
                          ),
                          title: Text(team.team.name),
                          subtitle: Text('Estado: ${getTeamState(team.id)}'),
                          trailing: getTeamState(team.id) == 'pendiente'
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.check,
                                          color: Colors.green),
                                      onPressed: () async {
                                        final acept =
                                            AcceptTeamRequest(teamId: team.id);
                                        await ref.read(acceptTeamProvider(
                                          tuple2(widget.id, acept),
                                        ).future);
                                        setTeamState(team.id, 'aceptado');
                                        Future.microtask(
                                          () {
                                            ScaffoldMessenger.of(context)
                                                .clearSnackBars();
                                            return ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'El equipo ${team.team.name} ha sido aceptado'),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.clear,
                                          color: Colors.red),
                                      onPressed: () async {
                                        final reject =
                                            RejectTeamRequest(teamId: team.id);
                                        await ref.read(rejectTeamProvider(
                                          tuple2(widget.id, reject),
                                        ).future);
                                        setTeamState(team.id, 'rechazado');
                                        Future.microtask(
                                          () {
                                            ScaffoldMessenger.of(context)
                                                .clearSnackBars();
                                            return ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'El equipo ${team.team.name} ha sido rechazado'),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                )
                              : null,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
