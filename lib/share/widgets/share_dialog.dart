import 'package:flutter/material.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareDialog extends StatelessWidget {
  const ShareDialog({super.key});

  static const largeShareDialogHeight = 600.0;

  @override
  Widget build(BuildContext context) {
    final isSmall =
        MediaQuery.of(context).size.width <= PhotoboothBreakpoints.small;
    return HoloBoothAlertDialog(
      height: isSmall ? 900 : largeShareDialogHeight,
      width: isSmall ? 500 : 900,
      child: const ShareDialogBody(),
    );
  }
}
