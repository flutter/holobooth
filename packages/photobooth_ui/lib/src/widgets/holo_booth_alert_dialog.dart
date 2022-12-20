import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class HoloBoothAlertDialog extends StatelessWidget {
  const HoloBoothAlertDialog({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: PhotoboothColors.transparent,
      content: GradientFrame(child: child),
    );
  }
}
