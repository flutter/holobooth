import 'package:flutter/material.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

/// {@template gradient_frame}
/// Wrap the [child] on frame with a [gradient].
/// {@endtemplate}
class GradientFrame extends StatelessWidget {
  /// {@macro gradient_frame}
  const GradientFrame({
    required this.child,
    this.height,
    this.width,
    this.borderWidth = 1,
    this.borderRadius = 38,
    this.backgroundColor,
    this.gradient,
    super.key,
  });

  /// Child of the frame.
  final Widget child;

  /// Height of the frame.
  final double? height;

  /// Width of the frame.
  final double? width;

  /// Border of the frame. It will be colored with the [gradient]
  final double borderWidth;

  /// Border radius of the frame.
  final double borderRadius;

  /// Background color of the whole container.
  final Color? backgroundColor;

  /// Gradient applied to the border.
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(borderWidth),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: gradient ?? HoloBoothGradients.secondarySix,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor ?? HoloBoothColors.modalSurface,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: child,
        ),
      ),
    );
  }
}
