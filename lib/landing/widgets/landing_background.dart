import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class LandingBackground extends StatelessWidget {
  const LandingBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      key: Key('landingPage_background'),
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
