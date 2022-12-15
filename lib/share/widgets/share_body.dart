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
    final photo = AnimatedPhotoboothPhoto(image: image);

    return Align(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ResponsiveLayoutBuilder(
          small: (context, _) {
            return Column(
              children: [
                photo,
                _ShareBodyContent(
                  smallScreen: true,
                  image: image,
                ),
              ],
            );
          },
          large: (context, _) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(child: photo),
                    Expanded(
                      child: _ShareBodyContent(
                        smallScreen: false,
                        image: image,
                      ),
                    )
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ShareBodyContent extends StatelessWidget {
  const _ShareBodyContent({
    required this.smallScreen,
    required this.image,
  });

  final bool smallScreen;
  final PhotoboothCameraImage image;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      mainAxisAlignment:
          smallScreen ? MainAxisAlignment.start : MainAxisAlignment.center,
      crossAxisAlignment:
          smallScreen ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        ShareHeading(smallScreen: smallScreen),
        const SizedBox(height: 24),
        ShareSubheading(smallScreen: smallScreen),
        const SizedBox(height: 32),
        Wrap(
          direction: smallScreen ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 24,
          runSpacing: 24,
          children: [
            ShareButton(image: image),
            GradientOutlinedButton(
              onPressed: () {
                // TODO(Laura177): add file to download.
              },
              icon: const Icon(Icons.file_download_rounded),
              label: Text(l10n.sharePageDownloadButtonText),
            ),
            GradientOutlinedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(PhotoBoothPage.route());
              },
              icon: const Icon(Icons.videocam_rounded),
              label: Text(l10n.sharePageRetakeButtonText),
            ),
          ],
        ),
      ],
    );
  }
}
