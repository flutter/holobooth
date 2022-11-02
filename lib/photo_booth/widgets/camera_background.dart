import 'package:flutter/material.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';

class CameraBackground extends StatelessWidget {
  const CameraBackground({
    super.key,
    required this.aspectRatio,
    required this.child,
  });

  final double aspectRatio;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const PhotoboothBackground(),
        Center(
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: child,
          ),
        ),
      ],
    );
  }
}
