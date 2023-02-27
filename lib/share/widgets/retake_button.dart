import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth/photo_booth/photo_booth.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class RetakeButton extends StatelessWidget {
  const RetakeButton({super.key, required this.camera});

  final CameraDescription? camera;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GradientOutlinedButton(
      onPressed: () {
        Navigator.of(context).pushReplacement(PhotoBoothPage.route(camera));
      },
      icon: const Icon(
        Icons.videocam_rounded,
        color: HoloBoothColors.white,
      ),
      label: l10n.sharePageRetakeButtonText,
    );
  }
}
