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
      body: CustomScrollView(
        slivers: [
          _Photos(images: images),
        ],
      ),
    );
  }
}

class _Photos extends StatelessWidget {
  const _Photos({required this.images});

  final List<PhotoboothCameraImage> images;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((context, index) {
        final image = images[index];
        return PreviewImage(
          data: image.data,
          height: 200,
          width: 100,
        );
      }, childCount: images.length),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
    );
  }
}
