import 'package:flutter/material.dart';
import 'package:io_photobooth/external_links/external_links.dart';
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
                  small: (_, __) => const MobileButtonsLayout(),
                  large: (_, __) => const DesktopButtonsLayout(),
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
  });

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
          children: [
            const Flexible(child: DownloadButton()),
            const SizedBox(width: 36),
            Flexible(child: ShareButton()),
            const SizedBox(width: 36),
            const GoToGoogleIOButton(),
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
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const DownloadButton(),
        const SizedBox(height: 20),
        ShareButton(),
        const SizedBox(height: 20),
        const GoToGoogleIOButton(),
      ],
    );
  }
}

@visibleForTesting
class GoToGoogleIOButton extends StatelessWidget {
  const GoToGoogleIOButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: PhotoboothColors.white),
      onPressed: launchGoogleIOLink,
      child: Text(
        l10n.goToGoogleIOButtonText,
        style: theme.textTheme.button?.copyWith(color: PhotoboothColors.black),
      ),
    );
  }
}

@visibleForTesting
class DownloadButton extends StatelessWidget {
  const DownloadButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return OutlinedButton(
      onPressed: () {
        // TODO(Laura177): add file to download.
      },
      child: Text(l10n.sharePageDownloadButtonText),
    );
  }
}
