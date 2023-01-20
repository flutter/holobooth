import 'package:flutter/material.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class NextButton extends StatefulWidget {
  const NextButton({super.key, required this.onNextPressed});

  final VoidCallback onNextPressed;

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  final _audioPlayerController = AudioPlayerController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AudioPlayer(
      audioAssetPath: Assets.audio.buttonPress,
      controller: _audioPlayerController,
      child: GradientElevatedButton(
        onPressed: () {
          _audioPlayerController.playAudio();
          widget.onNextPressed();
        },
        child: Text(l10n.nextButtonText),
      ),
    );
  }
}
