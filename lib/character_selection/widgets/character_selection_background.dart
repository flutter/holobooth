import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class CharacterSelectionBackground extends StatelessWidget {
  const CharacterSelectionBackground({super.key});

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

class CharacterSelectionBackgroundOverlay extends StatelessWidget {
  const CharacterSelectionBackgroundOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.5),
            Colors.black.withOpacity(0),
          ],
        ),
      ),
    );
  }
}
