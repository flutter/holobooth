import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class HoloBoothAlertDialog extends StatelessWidget {
  const HoloBoothAlertDialog(
      {super.key, required this.child, this.height, this.width});

  final Widget child;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: PhotoboothColors.transparent,
      content: GradientFrame(
        height: height,
        width: width,
        child: child,
      ),
    );
  }
}
