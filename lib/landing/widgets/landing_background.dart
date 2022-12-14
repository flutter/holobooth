import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';

class LandingBackground extends StatelessWidget {
  const LandingBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Assets.backgrounds.landingBackground.image(
      key: const Key('landingPage_background'),
      fit: BoxFit.cover,
    );
  }
}
