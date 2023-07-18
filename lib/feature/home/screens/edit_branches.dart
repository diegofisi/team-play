import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_uid_provider.dart';
import 'package:team_play/feature/home/entities/tournament.dart';
import 'package:team_play/feature/home/models/register_team_result_request.dart';
import 'package:team_play/feature/home/providers/profile_provider.dart';
import 'package:team_play/feature/home/providers/tournament_provider.dart';
import 'package:team_play/feature/shared/widgets/form/goal_form_field.dart';

class EditBranches extends ConsumerStatefulWidget {
  final String id;
  const EditBranches({required this.id, super.key});

  @override
  EditBranchesState createState() => EditBranchesState();
}

class EditBranchesState extends ConsumerState<EditBranches> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        return [uid, tournament, userProfile];
      } catch (e) {
        return [];
      }
    }

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
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/home/:$uid'),
            ),
            title: const Text('Branch Manager'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                tournament.matches.isNotEmpty
                    ? Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: ListView.builder(
                            itemCount: tournament.matches.length,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final match = tournament.matches[index];
                              return Card(
                                key: Key('${match.team1.id}-${match.team2.id}'),
                                margin: const EdgeInsets.all(8),
                                elevation: 4,
                                child: ListTile(
                                  leading: const Icon(Icons
                                      .sports_soccer), // O cualquier otro ícono que te guste
                                  title: Text(
                                      '${match.team1.name} vs ${match.team2.name}'),
                                  trailing: TextButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  title: Text(match.team1.name),
                                                  subtitle: GoalFormField(
                                                      controller: controller1),
                                                ),
                                                const Divider(),
                                                ListTile(
                                                  title: Text(match.team2.name),
                                                  subtitle: GoalFormField(
                                                      controller: controller2),
                                                ),
                                                TextButton(
                                                  onPressed: match.result == ""
                                                      ? null
                                                      : () async {
                                                          final teamWinner = RegisterTeamResultRequest(
                                                              teamId: int.parse(
                                                                          controller1
                                                                              .text) >
                                                                      int.parse(
                                                                          controller2
                                                                              .text)
                                                                  ? match
                                                                      .team1.id
                                                                  : match
                                                                      .team2.id,
                                                              result:
                                                                  "${match.team1.name}: ${controller1.text}-${match.team2.name}: ${controller2.text}");
                                                          final tupla = tuple3(
                                                            widget.id,
                                                            match.id,
                                                            teamWinner,
                                                          );
                                                          ref.read(
                                                              registerResultMatchProvider(
                                                                      tupla)
                                                                  .future);
                                                          setState(() {
                                                            controller1.clear();
                                                            controller2.clear();
                                                          });
                                                          Navigator.pop(
                                                              context); // Cierra el modal después de registrar el resultado
                                                        },
                                                  child: const Text(
                                                      'Registrar resultado'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: const Text('Administrar partido'),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Container(),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    await ref.read(generateNextRoundProvider(widget.id).future);
                    setState(() {
                      controller1.clear();
                      controller2.clear();
                    });
                  },
                  child: const Text('Generar siguiente ronda'),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }
}
