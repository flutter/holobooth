import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GradientOutlinedButton(
      icon: const Icon(
        Icons.file_download_rounded,
        color: PhotoboothColors.white,
      ),
      label: l10n.sharePageDownloadButtonText,
    );
  }
}
