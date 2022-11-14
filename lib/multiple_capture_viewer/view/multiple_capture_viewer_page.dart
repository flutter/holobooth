import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/multiple_capture_viewer/multiple_capture_viewer.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
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
          const _Background(),
          const Align(
            alignment: Alignment.topLeft,
            child: TakePhotoAgainButton(),
          ),
          Align(child: _Body(images: images)),
        ],
      ),
    );
  }
}

@visibleForTesting
class TakePhotoAgainButton extends StatelessWidget {
  const TakePhotoAgainButton({super.key});

  static const buttonKey = Key('takePhotoAgainButton_appTooltipButton');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Semantics(
      focusable: true,
      button: true,
      label: l10n.retakePhotoButtonLabelText,
      child: AppTooltipButton(
        key: buttonKey,
        verticalOffset: 50,
        onPressed: () {
          Navigator.of(context).pushReplacement(PhotoBoothPage.route());
        },
        message: l10n.retakeButtonTooltip,
        child: Assets.icons.retakeButtonIcon.image(height: 100),
      ),
    );
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
            style: theme.textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          const ShareButton(),
        ],
      ),
    );
  }
}
