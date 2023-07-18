import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_uid_provider.dart';
import 'package:team_play/feature/home/entities/tournament.dart';
import 'package:team_play/feature/home/providers/tournament_provider.dart';

class TournamentBranches extends ConsumerStatefulWidget {
  final String tournamentId;
  const TournamentBranches({required this.tournamentId, super.key});

  @override
  TournamentBranchesState createState() => TournamentBranchesState();
}

class TournamentBranchesState extends ConsumerState<TournamentBranches> {
  Future<List> initData(BuildContext context, WidgetRef ref) async {
    try {
      final uid = await ref.read(firebaseUIDProvider.notifier).getUid();
      if (uid == null) {
        Future.microtask(() => context.go('/login'));
        return [];
      }
      final tournament =
          await ref.watch(getTournamentProvider(widget.tournamentId).future);
      return [uid, tournament];
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
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
            leading: IconButton(
              onPressed: () async {
                Future.microtask(() => context.go('/home/:$uid'));
              },
              icon: const Icon(Icons.arrow_back),
            ),
            centerTitle: true,
            title: Text(tournament.name),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.list, color: Colors.green),
                      SizedBox(width: 10),
                      Text(
                        'Branches',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: tournament.matches.length,
                    itemBuilder: (context, index) {
                      print(tournament.teams.length);

                      String phase =
                          getMatchPhase(index, tournament.matches.length);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0 ||
                              getMatchPhase(
                                      index - 1, tournament.matches.length) !=
                                  phase)
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                phase,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          Card(
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: ListTile(
                              leading: const Icon(Icons.sports_soccer,
                                  color: Colors.blue),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '${tournament.matches[index].team1.name} vs ${tournament.matches[index].team2.name}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Resultado: ${tournament.matches[index].result}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () async {},
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

String getMatchPhase(int matchIndex, int totalTeams) {
  if (totalTeams == 1) {
    return 'Final';
  }
  if (totalTeams == 3) {
    if (matchIndex < 2) {
      return 'Semifinal';
    }
    return 'Final';
  }
  if (totalTeams == 7) {
    if (matchIndex < 4) {
      return 'Cuartos de final';
    } else if (matchIndex < 6) {
      return 'Semifinal';
    } else {
      return 'Final';
    }
  }
  return '';
}
