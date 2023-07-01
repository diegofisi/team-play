import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_uid_provider.dart';
import 'package:team_play/feature/home/providers/boton_navigation_provider.dart';
import 'package:team_play/feature/home/screens/games_screen.dart';
import 'package:team_play/feature/home/screens/league_screen.dart';
import 'package:team_play/feature/home/screens/setting_screen.dart';
import 'package:team_play/feature/home/screens/tournament_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    final uid = ref.read(firebaseUIDProvider.notifier).getUid();
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          GamesScreen(), // Home screen content
          SettingsScreen(),
          MyTournamentsScreen(),
          LeaguesScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Mis Torneos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.travel_explore_sharp),
            label: 'Ligas',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          ref.read(selectedIndexProvider.notifier).state = index;
        },
      ),
    );
  }
}


