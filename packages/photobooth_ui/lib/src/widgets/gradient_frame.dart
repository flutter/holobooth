import 'package:flutter/material.dart';

class GradientFrame extends StatelessWidget {
  const GradientFrame({
    super.key,
    required this.child,
    this.height,
    this.width,
  });

  final Widget child;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(38),
        gradient: const LinearGradient(
          colors: <Color>[
            Color(0xFF9E81EF),
            Color(0xFF4100E0),
          ],
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF020320).withOpacity(0.95),
          borderRadius: BorderRadius.circular(38),
        ),
        child: child,
      ),
    );
  }
}
