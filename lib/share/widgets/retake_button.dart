import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class RetakeButton extends StatelessWidget {
  const RetakeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GradientOutlinedButton(
      onPressed: () {
        Navigator.of(context).pushReplacement(PhotoBoothPage.route());
      },
      icon: const Icon(
        Icons.videocam_rounded,
        color: PhotoboothColors.white,
      ),
      label: l10n.sharePageRetakeButtonText,
    );
  }
}
