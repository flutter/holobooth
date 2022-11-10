import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            PhotoboothColors.purple,
            PhotoboothColors.blue,
          ],
        ),
      ),
    );
  }
}
