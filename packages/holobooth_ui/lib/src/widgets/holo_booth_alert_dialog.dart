import 'package:flutter/material.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

/// {@template holo_booth_alert_dialog}
/// Wrap a [child] in the content of [AlertDialog] with a [GradientFrame]
/// {@endtemplate}
class HoloBoothAlertDialog extends StatelessWidget {
  /// {@macro holo_booth_alert_dialog}
  const HoloBoothAlertDialog({
    required this.child,
    super.key,
    this.height,
    this.width,
    this.borderRadius = 38,
  });

  /// Widget wrapped on the dialog.
  final Widget child;

  /// Height of the dialog.
  final double? height;

  /// Width of the dialog.
  final double? width;

  /// Border radius of the dialog.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: HoloBoothColors.transparent,
      content: GradientFrame(
        borderRadius: borderRadius,
        height: height,
        width: width,
        child: child,
      ),
    );
  }
}
