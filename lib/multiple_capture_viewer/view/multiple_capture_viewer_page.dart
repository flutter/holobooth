import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/multiple_capture/multiple_capture.dart';
import 'package:io_photobooth/multiple_capture_viewer/multiple_capture_viewer.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class MultipleCaptureViewerPage extends StatelessWidget {
  const MultipleCaptureViewerPage({super.key, required this.images});

  final List<PhotoboothCameraImage> images;

  static Route<void> route(List<PhotoboothCameraImage> images) {
    return AppPageRoute<void>(
      builder: (_) => MultipleCaptureViewerPage(images: images),
    );
  }

  @override
  Widget build(BuildContext context) =>
      MultipleCaptureViewerView(images: images);
}

class MultipleCaptureViewerView extends StatelessWidget {
  const MultipleCaptureViewerView({super.key, required this.images});

  final List<PhotoboothCameraImage> images;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        _Background(),
        Align(alignment: Alignment.center, child: _Body(images: images)),
      ],
    ));
  }
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            PhotoboothColors.gray,
            PhotoboothColors.white,
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.images});

  final List<PhotoboothCameraImage> images;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MultiplePhotosLayout(images: images),
          SelectableText(
            l10n.sharePageHeading,
            style: theme.textTheme.headline1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
