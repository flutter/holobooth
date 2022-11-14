import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/multiple_capture_viewer/multiple_capture_viewer.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ElevatedButton(
      onPressed: () async {
        await showAppModal<void>(
          context: context,
          portraitChild: const ShareBottomSheet(),
          landscapeChild: const ShareDialog(),
        );
      },
      child: Text(l10n.sharePageShareButtonText),
    );
  }
}
