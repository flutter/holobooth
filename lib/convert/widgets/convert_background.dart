import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';

class ConvertBackground extends StatelessWidget {
  const ConvertBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Assets.backgrounds.loadingBackground.image(
      key: const Key('LoadingOverlay_LoadingBackground'),
      fit: BoxFit.cover,
    );
  }
}
