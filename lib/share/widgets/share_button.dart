import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/multiple_capture_viewer/multiple_capture_viewer.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({
    super.key,
    this.platformHelper,
  });

  /// Optional [PlatformHelper] instance.
  ///
  /// Used to decide whether to show a [ShareBottomSheet] or [ShareDialog].
  final PlatformHelper? platformHelper;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ElevatedButton(
      onPressed: () async {
        await showAppModal<void>(
          context: context,
          platformHelper: platformHelper,
          portraitChild: const ShareBottomSheet(),
          landscapeChild: const ShareDialog(),
        );
      },
      child: Text(l10n.sharePageShareButtonText),
    );
  }
}
