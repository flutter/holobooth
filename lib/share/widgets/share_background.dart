import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';

class ShareBackground extends StatelessWidget {
  const ShareBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Assets.backgrounds.shareBackground.image(
      fit: BoxFit.cover,
    );
  }
}
