import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// {@template holo_booth_alert_dialog}
/// Wrap a [child] in the content of [AlertDialog] with a [GradientFrame]
/// {@endtemplate}
class HoloBoothAlertDialog extends StatelessWidget {
  /// {@macro holo_booth_alert_dialog}
  const HoloBoothAlertDialog({
    super.key,
    required this.child,
    this.height,
    this.width,
  });

  /// Widget wrapped on the dialog.
  final Widget child;

  /// Height of the dialog.
  final double? height;

  /// Width of the dialog.
  final double? width;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: HoloBoothColors.transparent,
      content: GradientFrame(
        height: height,
        width: width,
        child: child,
      ),
    );
  }
}
