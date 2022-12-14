import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';

class AnimojiIntroBackground extends StatelessWidget {
  const AnimojiIntroBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Assets.backgrounds.animojiIntroBackground.image(
      key: const Key('animojiIntro_background'),
      fit: BoxFit.cover,
    );
  }
}
