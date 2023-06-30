import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_logout_provider.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_uid_provider.dart';
import 'package:team_play/feature/auth/presentation/providers/user_information_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text("bienvenido al home"),
            TextButton(
              onPressed: () async {
                await ref.read(firebaseLogoutProvider.notifier).logout();
                Future.microtask(() => context.go("/login"));
              },
              child: const Text("logout"),
            ),
            TextButton(
              onPressed: () async {
                final user = await ref
                    .read(userRepositoryProvider.notifier)
                    .retrieveUser();
                print("el user es : ${user?.email}");
              },
              child: Text("Conseguir usuario"),
            ),
            TextButton(
              onPressed: () async {
                final uid =
                    await ref.read(firebaseUIDProvider.notifier).getUid();
                print("el uid es : $uid");
              },
              child: Text("data"),
            ),

            //get ubication from package geolocator without riverpod
            TextButton(
              onPressed: () async {
                final position = await determinePosition();
                print("la latitud es : ${position.latitude}");
                print("la longitud es : ${position.longitude}");
              },
              child: Text("ubicacion"),
            ),
            TextButton(
              onPressed: () {},
              child: Text("Pasarela de pagos"),
            ),
          ],
        ),
      ),
    );
  }
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition();
}
