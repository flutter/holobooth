import 'package:flutter/material.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class SharePage extends StatelessWidget {
  const SharePage({required this.images, super.key});

  final List<PhotoboothCameraImage> images;

  static Route<void> route(List<PhotoboothCameraImage> images) {
    return AppPageRoute(
      builder: (_) => SharePage(
        images: images,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPageView(
        background: const GradientBackground(),
        body: ShareBody(
          images: images,
        ),
        footer: const FullFooter(),
      ),
    );
  }
}
