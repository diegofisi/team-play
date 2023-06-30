import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:team_play/feature/home/screens/map_screen.dart';

class GameRegistration extends StatefulWidget {
  const GameRegistration({super.key});

  @override
  GameRegistrationState createState() => GameRegistrationState();
}

class GameRegistrationState extends State<GameRegistration> {
  LatLng? gameLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Registrar Partido'),
      ),
      body: Column(
        children: [
          Container(
            width: 400,
            height: 400,
            child: MyMap(
              onMarkerMoved: (newLocation) {
                setState(() {
                  gameLocation = newLocation;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (gameLocation != null) {
                print(
                    'El partido se llevará a cabo en: ${gameLocation!.latitude}, ${gameLocation!.longitude}');
              }
            },
            child: Text('Registrar Partido'),
          ),
        ],
      ),
    );
  }
}
