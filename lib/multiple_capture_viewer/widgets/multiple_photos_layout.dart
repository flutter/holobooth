import 'package:flutter/material.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class MultiplePhotosLayout extends StatelessWidget {
  const MultiplePhotosLayout({super.key, required this.images});

  final List<PhotoboothCameraImage> images;
  static const reductionFactor = 0.19;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      children: [
        for (final image in images)
          PreviewImage(
            data: image.data,
            height: image.constraint.height * reductionFactor,
            width: image.constraint.width * reductionFactor,
          )
      ],
    );
  }
}
