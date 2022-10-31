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

class CharacterSelectionBackground1 extends StatelessWidget {
  const CharacterSelectionBackground1({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            PhotoboothColors.black.withOpacity(0.5),
            PhotoboothColors.transparent,
          ],
        ),
      ),
    );
  }
}
