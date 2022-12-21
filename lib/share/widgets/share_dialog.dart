import 'package:flutter/material.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareDialog extends StatelessWidget {
  const ShareDialog({super.key});

  static const largeShareDialogHeight = 600.0;
  static const _largeShareDialogWidth = 900.0;
  static const _smallShareDialogHeight = 900.0;
  static const _smallShareDialogWidth = 500.0;

  @override
  Widget build(BuildContext context) {
    final isSmall =
        MediaQuery.of(context).size.width <= PhotoboothBreakpoints.small;
    return HoloBoothAlertDialog(
      height: isSmall ? _smallShareDialogHeight : largeShareDialogHeight,
      width: isSmall ? _smallShareDialogWidth : _largeShareDialogWidth,
      child: const ShareDialogBody(),
    );
  }
}
