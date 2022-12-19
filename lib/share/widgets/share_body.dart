import 'package:flutter/material.dart';
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
                const _ShareBodyContent(isSmallScreen: true),
              ],
            );
          },
          large: (context, _) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(child: photo),
                    const Expanded(
                      child: _ShareBodyContent(isSmallScreen: false),
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
    required this.isSmallScreen,
  });

  final bool isSmallScreen;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:
          isSmallScreen ? MainAxisAlignment.start : MainAxisAlignment.center,
      crossAxisAlignment:
          isSmallScreen ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        const ShareHeading(),
        const SizedBox(height: 24),
        const ShareSubheading(),
        const SizedBox(height: 32),
        Wrap(
          direction: isSmallScreen ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 24,
          runSpacing: 24,
          children: const [
            ShareButton(),
            DownloadButton(),
            RetakeButton(),
          ],
        ),
      ],
    );
  }
}
