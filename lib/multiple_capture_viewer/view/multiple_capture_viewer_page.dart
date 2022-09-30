import 'package:flutter/material.dart';
import 'package:io_photobooth/multiple_capture/multiple_capture.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class MultipleCaptureViewerPage extends StatelessWidget {
  const MultipleCaptureViewerPage({super.key, required this.images});

  final List<PhotoboothCameraImage> images;

  static Route<void> route(List<PhotoboothCameraImage> images) {
    return AppPageRoute<void>(
      builder: (_) => MultipleCaptureViewerPage(
        images: images,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
          return PreviewImage(
            data: image.data,
            height: 200,
            width: 100,
          );
        },
      ),
    );
  }
}
