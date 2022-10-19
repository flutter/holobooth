import 'package:flutter/material.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';

class CharacterSelectionBody extends StatelessWidget {
  const CharacterSelectionBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 104),
          SelectableText(
            'Choose your character',
            style: theme.textTheme.headline1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SelectableText(
            'You can change them later',
            style: theme.textTheme.headline3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 53),
          const CharacterSelector(),
        ],
      ),
    );
  }
}
