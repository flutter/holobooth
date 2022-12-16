import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareBody extends StatelessWidget {
  const ShareBody({required this.images, super.key});

  final List<PhotoboothCameraImage> images;

  @override
  Widget build(BuildContext context) {
    final image = images.first;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AnimatedPhotoIndicator(),
          AnimatedPhotoboothPhoto(image: image),
          AnimatedFadeIn(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ShareHeading(),
                const SizedBox(height: 20),
                ResponsiveLayoutBuilder(
                  small: (_, __) => MobileButtonsLayout(
                    image: image,
                  ),
                  large: (_, __) => DesktopButtonsLayout(
                    image: image,
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

@visibleForTesting
class DesktopButtonsLayout extends StatelessWidget {
  const DesktopButtonsLayout({
    super.key,
    required this.image,
  });

  final PhotoboothCameraImage image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ShareSubheading(),
        const SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            ShareButton(),
            SizedBox(width: 36),
            DownloadButton(),
            SizedBox(width: 36),
            TakeANewPhoto(),
          ],
        ),
      ],
    );
  }
}

@visibleForTesting
class MobileButtonsLayout extends StatelessWidget {
  const MobileButtonsLayout({
    super.key,
    required this.image,
  });

  final PhotoboothCameraImage image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        ShareButton(),
        SizedBox(height: 16),
        DownloadButton(),
        SizedBox(height: 16),
        TakeANewPhoto(),
      ],
    );
  }
}

@visibleForTesting
class TakeANewPhoto extends StatelessWidget {
  const TakeANewPhoto({super.key});

  static const newPhotoButtonKey = Key('sharePage_newPhotoButtonKey');
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return OutlinedButton(
      key: newPhotoButtonKey,
      onPressed: () {
        Navigator.of(context).pushReplacement(PhotoBoothPage.route());
      },
      style: OutlinedButton.styleFrom(minimumSize: const Size(259, 54)),
      child: Text(
        l10n.takeANewPhotoButtonText,
        style: theme.textTheme.labelLarge?.copyWith(
          color: PhotoboothColors.white,
        ),
      ),
    );
  }
}

@visibleForTesting
class DownloadButton extends StatelessWidget {
  const DownloadButton({super.key});

  static const downloadButtonKey = Key('sharePage_downloadButtonkey');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return ElevatedButton(
      key: downloadButtonKey,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(184, 54),
      ),
      onPressed: () {
        // TODO(Laura177): add file to download.
      },
      child: Text(
        l10n.sharePageDownloadButtonText,
        style: theme.textTheme.labelLarge?.copyWith(
          color: PhotoboothColors.white,
        ),
      ),
    );
  }
}
