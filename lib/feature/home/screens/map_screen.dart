import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:team_play/feature/shared/helpers/determine_position.dart';
import 'package:url_launcher/url_launcher.dart';

class MyMap extends StatefulWidget {
  final Function(LatLng position)? onMarkerMoved;
  const MyMap({super.key, this.onMarkerMoved});

  @override
  MyMapState createState() => MyMapState();
}

class MyMapState extends State<MyMap> {
  final MapController _mapController = MapController();
  Marker? _marker;
  Future<Position>? _positionFuture;

  @override
  void initState() {
    super.initState();
    _positionFuture = determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
      future: _positionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          ); // loading state
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // error state
        }
        final position = snapshot.data;
        if (_marker == null && position != null) {
          _marker = Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(
                position.latitude, position.longitude), // initial position
            builder: (ctx) => const Icon(
              Icons.location_on,
              color: Color.fromARGB(255, 165, 8, 8),
              size: 40,
            ),
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onMarkerMoved?.call(_marker!.point);
          });
        }
        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: LatLng(
                position?.latitude ?? -12.05, position?.longitude ?? -77.05),
            zoom: 13.5,
            onTap: _handleTap,
          ),
          nonRotatedChildren: [
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () =>
                      _launchURL('https://openstreetmap.org/copyright'),
                ),
              ],
            ),
          ],
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.playteam.app',
            ),
            if (_marker != null)
              MarkerLayer(
                markers: [_marker!],
              ),
          ],
        );
      },
    );
  }

  void _handleTap(TapPosition position, LatLng latlng) {
    setState(() {
      _marker = Marker(
        width: 80.0,
        height: 80.0,
        point: latlng,
        builder: (ctx) => const FlutterLogo(),
      );
    });
    if (_marker != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onMarkerMoved?.call(_marker!.point);
      });
    }
  }

  void _launchURL(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
      return;
    } catch (e) {
      return;
    }
  }
}
