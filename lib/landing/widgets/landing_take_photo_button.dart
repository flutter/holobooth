import 'package:flutter/material.dart';
import 'package:io_photobooth/example_audio_loop.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class LandingTakePhotoButton extends StatelessWidget {
  const LandingTakePhotoButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push<void>(ExampleAudioLoop.route());
      },
      child: Text(l10n.landingPageTakePhotoButtonText),
    );
  }
}
