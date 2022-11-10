import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';

class ShareButton extends StatelessWidget {
  ShareButton({
    super.key,
    PlatformHelper? platformHelper,
  }) : platformHelper = platformHelper ?? PlatformHelper();

  /// Optional [PlatformHelper] instance.
  final PlatformHelper platformHelper;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return ElevatedButton(
      key: const Key('sharePage_share_elevatedButton'),
      style: ElevatedButton.styleFrom(
        // padding: const EdgeInsets.all(10),
        backgroundColor: PhotoboothColors.white,
        minimumSize: const Size(139, 54),
      ),
      onPressed: () {
        // TODO(Laura177): replace with share modal.
      },
      child: Text(
        l10n.sharePageShareButtonText,
        style: theme.textTheme.button?.copyWith(
          color: PhotoboothColors.blue,
          fontSize: 22,
        ),
      ),
    );
  }
}
