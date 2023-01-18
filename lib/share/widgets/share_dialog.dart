import 'package:flutter/material.dart';
import 'package:holobooth/share/share.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class ShareDialog extends StatelessWidget {
  const ShareDialog({super.key});

  static const largeShareDialogHeight = 600.0;
  static const _largeShareDialogWidth = 1000.0;
  static const _smallShareDialogHeight = 900.0;
  static const _smallShareDialogWidth = 500.0;

  @override
  Widget build(BuildContext context) {
    final isSmall =
        MediaQuery.of(context).size.width <= HoloboothBreakpoints.small;
    return HoloBoothAlertDialog(
      height: isSmall ? _smallShareDialogHeight : largeShareDialogHeight,
      width: isSmall ? _smallShareDialogWidth : _largeShareDialogWidth,
      child: const ShareDialogBody(),
    );
  }
}
