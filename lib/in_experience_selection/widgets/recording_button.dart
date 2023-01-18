import 'package:flutter/material.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class RecordingButton extends StatefulWidget {
  const RecordingButton({super.key, required this.onRecordingPressed});

  final VoidCallback onRecordingPressed;

  @override
  State<RecordingButton> createState() => _RecordingButtonState();
}

class _RecordingButtonState extends State<RecordingButton>
    with AudioPlayerMixin {
  @override
  String get audioAssetPath => Assets.audio.counting3Seconds;

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
        widget.onRecordingPressed();
      },
      child: Text(l10n.recordButtonText),
    );
  }
}
