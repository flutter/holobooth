import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';

class CharacterSelector extends StatelessWidget {
  const CharacterSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: _Character(
            name: 'Dash',
            image: Assets.characters.dash.image(),
          ),
        ),
        const SizedBox(width: 42),
        Flexible(
          child: _Character(
            name: 'Sparky',
            image: Assets.characters.sparky.image(),
          ),
        ),
      ],
    );
  }
}

class _Character extends StatelessWidget {
  const _Character({
    super.key,
    required this.name,
    required this.image,
  });

  final String name;
  final Image image;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(
          width: 300,
          child: image,
        ),
        const SizedBox(height: 35.67),
        SelectableText(
          name,
          style: theme.textTheme.headline1,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
