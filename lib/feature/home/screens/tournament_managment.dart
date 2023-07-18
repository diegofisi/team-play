import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/home/providers/boton_navigation_provider.dart';
import 'package:team_play/feature/home/screens/edit_branches.dart';
import 'package:team_play/feature/home/screens/team_confirmed.dart';

class TournamentManager extends ConsumerStatefulWidget {
  final String tournamentId;
  const TournamentManager({
    required this.tournamentId,
    super.key,
  });

  @override
  TournamentManagerState createState() => TournamentManagerState();
}

class TournamentManagerState extends ConsumerState<TournamentManager> {
  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedIndexTournamentProvider);
    return Scaffold(
      body: selectedIndex == 0
          ? TeamConfirmed(id: widget.tournamentId)
          : EditBranches(id: widget.tournamentId),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Teams',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lan_sharp),
            label: 'Branches',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          ref.read(selectedIndexTournamentProvider.notifier).state = index;
        },
      ),
    );
  }
}
