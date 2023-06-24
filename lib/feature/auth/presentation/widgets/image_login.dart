import 'package:flutter/material.dart';

class ImageLogin extends StatelessWidget {
  const ImageLogin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo/login_image.png',
      height: 400,
      color: Colors.black.withOpacity(0.63),
    );
  }
}