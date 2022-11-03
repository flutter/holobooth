import 'package:flutter/material.dart';

class CharacterSelectionBackground extends StatelessWidget {
  const CharacterSelectionBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xffBB42F4).withOpacity(1),
            const Color(0xff428eff).withOpacity(1),
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
            const Color(0xff000000).withOpacity(0.5),
            const Color(0xff000000).withOpacity(0),
          ],
        ),
      ),
    );
  }
}
