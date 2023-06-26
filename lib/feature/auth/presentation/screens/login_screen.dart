import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_uid_provider.dart';
import 'package:team_play/feature/auth/presentation/widgets/custom_wave.dart';
import 'package:team_play/feature/auth/presentation/widgets/google_button_login.dart';

import '../widgets/image_login.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Stack(
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
                  SizedBox(height: size.height * 0.35),
                  const ImageLogin(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const GoogleButtonLogin(),
                      TextButton(
                        onPressed: () async {
                          final result = await ref
                              .read(firebaseUIDProvider.notifier)
                              .getUid();
                          print("el uid es : $result");
                        },
                        child: Text("data"),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
