import 'package:flutter/material.dart';
import 'package:team_play/feature/auth/presentation/widgets/custom_wave.dart';
import 'package:team_play/feature/auth/presentation/widgets/google_button_login.dart';

import '../widgets/image_login.dart';

class Login2 extends StatelessWidget {
  const Login2({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          CustomWave(size: size),
          Positioned(
            right: size.width * 0.1,
            top: -size.height * 0.1,
            child: Image.asset(
              'assets/logo/team_play_logo.png',
              fit: BoxFit.contain,
              height: size.height * 0.5,
              width: size.width * 0.8,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 200),
                ImageLogin(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [GoogleButtonLogin(size: size)],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}





