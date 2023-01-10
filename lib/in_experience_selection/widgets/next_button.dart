import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/audio_player/audio_player.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class NextButton extends StatefulWidget {
  const NextButton({super.key, required this.onNextPressed});

  final VoidCallback onNextPressed;

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> with AudioPlayerMixin {
  @override
  String get audioAssetPath => Assets.audio.buttonPress;

  @override
  void initState() {
    super.initState();

    loadAudio();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GradientElevatedButton(
      onPressed: () {
        playAudio();
        widget.onNextPressed();
      },
      child: Text(l10n.nextButtonText),
    );
  }
}
