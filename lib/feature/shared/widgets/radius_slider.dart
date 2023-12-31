import 'package:flutter/material.dart';
import 'package:team_play/feature/shared/helpers/form.dart';
import 'package:team_play/feature/shared/helpers/slider_search.dart';

class RadiusSlider extends StatefulWidget {
  final RadiusInput radius;

  const RadiusSlider({
    required this.radius,
    Key? key,
  }) : super(key: key);

  @override
  RadiusSliderState createState() => RadiusSliderState();
}

class RadiusSliderState extends State<RadiusSlider> {
  late RadiusInput _radius;

  @override
  void initState() {
    super.initState();
    _radius = widget.radius;
    loadRadiusValue();
  }

  void loadRadiusValue() async {
    int radiusValue = await getRadiusValue();
    _radius = RadiusInput.dirty(radiusValue);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Radio de busqueda: ${_radius.value} km',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          Slider(
            value: _radius.value.toDouble(),
            min: 1.0,
            max: 150.0,
            divisions: 10,
            label: '${_radius.value} km',
            onChanged: (value) {
              setState(
                () {
                  _radius = RadiusInput.dirty(value.toInt());
                  saveRadiusValue(
                      _radius.value); // Guarda el valor cuando cambia
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
