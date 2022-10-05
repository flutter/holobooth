import 'package:flutter/material.dart';
import 'package:io_photobooth/multiple_capture/multiple_capture.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class MultiplePhotosLayout extends StatelessWidget {
  const MultiplePhotosLayout({super.key, required this.images});

  final List<PhotoboothCameraImage> images;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          for (final image in images)
            PreviewImage(
              data: image.data,
              height: 200,
              width: 100,
            )
        ],
      ),
    );
  }
}
