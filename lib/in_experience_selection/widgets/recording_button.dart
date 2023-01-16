import 'package:flutter/material.dart';
import 'package:holobooth_ui/holobooth_ui.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class RecordingButton extends StatelessWidget {
  const RecordingButton({super.key, required this.onRecordingPressed});

  final VoidCallback onRecordingPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GradientElevatedButton(
      onPressed: onRecordingPressed,
      child: Text(l10n.recordButtonText),
    );
  }
}
