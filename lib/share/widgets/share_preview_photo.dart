import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class SharePreviewPhoto extends StatelessWidget {
  const SharePreviewPhoto({
    super.key,
    required this.image,
  });

  final PhotoboothCameraImage image;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -5 * (math.pi / 180),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 400),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: PhotoboothColors.black54,
              blurRadius: 7,
              offset: Offset(-3, 9),
              spreadRadius: 1,
            ),
          ],
        ),
        child: const DecoratedBox(
          decoration: BoxDecoration(color: PhotoboothColors.blue),
        ),
      ),
    );
  }
}
