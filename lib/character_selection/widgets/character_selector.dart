import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';

class CharacterSelector extends StatelessWidget {
  const CharacterSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final characters = [
      _Character(
        name: 'Dash',
        image: Assets.characters.dash.image(),
      ),
      _Character(
        name: 'Sparky',
        image: Assets.characters.sparky.image(),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        print(constraints.maxWidth);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: _Character(
                name: 'Dash',
                image: Assets.characters.dash.image(),
              ),
            ),
            Flexible(
              flex: 1,
              child: ColoredBox(color: Colors.red),
            ),
            Flexible(
              flex: 2,
              child: _Character(
                name: 'Sparky',
                image: Assets.characters.sparky.image(),
              ),
            ),
          ],
        );
      },
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
        SizedBox.fromSize(
          size: Size.square(300),
          child: image,
        ),
        const SizedBox(height: 35.67),
        SelectableText(
          name,
          style: theme.textTheme.headline1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 11),
        SelectableText(
          'You can change them later',
          style: theme.textTheme.headline3,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
