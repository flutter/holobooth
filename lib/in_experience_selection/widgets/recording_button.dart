import 'package:flutter/material.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class RecordingButton extends StatefulWidget {
  const RecordingButton({
    required this.onRecordingPressed,
    super.key,
  });

  final VoidCallback onRecordingPressed;

  @override
  State<RecordingButton> createState() => _RecordingButtonState();
}

class _RecordingButtonState extends State<RecordingButton> {
  final _audioPlayerController = AudioPlayerController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AudioPlayer(
      audioAssetPath: Assets.audio.counting3Seconds,
      controller: _audioPlayerController,
      child: GradientElevatedButton(
        onPressed: () {
          _audioPlayerController.playAudio();
          widget.onRecordingPressed();
        },
        child: Text(l10n.recordButtonText),
      ),
    );
  }
}
