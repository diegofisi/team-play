import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'dart:math' as math;

class CustomWave extends StatelessWidget {
  final Size size;
  const CustomWave({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final Color black100 = Colors.black.withOpacity(0.1);
    final Color black200 = Colors.black.withOpacity(0.2);
    final Color black300 = Colors.black.withOpacity(0.3);
    final Color black400 = Colors.black.withOpacity(0.4);
    return Transform.scale(
      scale: 1,
      child: Transform.rotate(
        angle: math.pi,
        child: WaveWidget(
          config: CustomConfig(
            gradients: [
              [Colors.white, black100],
              [black100, black200],
              [black200, black300],
              [black300, black400],
            ],
            durations: [35000, 19440, 10800, 6000],
            heightPercentages: [0.20, 0.23, 0.25, 0.30],
            blur: const MaskFilter.blur(BlurStyle.solid, 10),
            gradientBegin: Alignment.bottomLeft,
            gradientEnd: Alignment.topRight,
          ),
          waveAmplitude: 3,
          size: Size(double.infinity, size.height * 0.5),
        ),
      ),
    );
  }
}
