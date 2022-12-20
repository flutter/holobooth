import 'package:flutter/material.dart';

class GradientFrame extends StatelessWidget {
  const GradientFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
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
