import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

/// Widget that displays a [child] with a background blurry effect
class BlurryContainer extends StatelessWidget {
  const BlurryContainer({
    Key? key,
    required this.child,
    this.height,
    this.width,
    this.blur = 5,
    this.color = Colors.transparent,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  }) : super(key: key);

  /// The child shown in top of the container.
  final Widget child;

  /// Height of the container.
  final double? height;

  /// Width of the container.
  final double? width;

  /// Blur value for the container.
  final double blur;

  /// Background color of the container.
  final Color color;

  /// Border radius for the container.
  final BorderRadius borderRadius;

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
          child: child,
        ),
      ),
    );
  }
}
