import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

/// {@template blurry_container}
/// Widget that displays a [child] with a background blurry effect.
/// {@endtemplate}

class BlurryContainer extends StatelessWidget {
  /// {@macro blurry_container}
  const BlurryContainer({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.blur = 4,
    this.color = Colors.transparent,
    this.padding = EdgeInsets.zero,
    this.borderRadius = BorderRadius.zero,
  });

  /// The child shown in top of the container.
  final Widget child;

  /// Height of the container.
  final double? height;

  /// Width of the container.
  final double? width;

  /// Blur value for the container. Default to 4.
  final double blur;

  /// Background color of the container.
  final Color color;

  /// Border radius for the container.
  final BorderRadius? borderRadius;

  /// Padding for the container.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          height: height,
          width: width,
          color: color,
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
