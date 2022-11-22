import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({
    super.key,
    this.platformHelper,
    required this.image,
  });

  /// Optional [PlatformHelper] instance.
  ///
  /// Used to decide whether to show a [ShareBottomSheet] or [ShareDialog].
  final PlatformHelper? platformHelper;

  final PhotoboothCameraImage image;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: PhotoboothColors.white,
      ),
      onPressed: () async {
        await showAppModal<void>(
          context: context,
          platformHelper: platformHelper,
          portraitChild: ShareBottomSheet(image: image),
          landscapeChild: ShareDialog(
            image: image,
          ),
        );
      },
      child: Text(
        l10n.sharePageShareButtonText,
        style: Theme.of(context)
            .textTheme
            .button
            ?.copyWith(color: PhotoboothColors.blue),
      ),
    );
  }
}
