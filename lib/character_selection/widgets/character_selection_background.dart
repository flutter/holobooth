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
            Color(0xffBB42F4).withOpacity(1),
            Color(0xff428eff).withOpacity(1),
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
            Color(0xff000000).withOpacity(0.5),
            Color(0xff000000).withOpacity(0),
          ],
        ),
      ),
    );
  }
}
