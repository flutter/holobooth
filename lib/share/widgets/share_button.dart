import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
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
    return ElevatedButton(
      key: const Key('sharePage_share_elevatedButton'),
      onPressed: () {
        // TODO(Laura177): replace with share modal.
      },
      child: Text(l10n.sharePageShareButtonText),
    );
  }
}
