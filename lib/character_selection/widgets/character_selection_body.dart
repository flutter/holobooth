import 'package:flutter/material.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class CharacterSelectionBody extends StatelessWidget {
  const CharacterSelectionBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: 600,
        width: 100,
        child: Stack(
          children: [
            Container(
              color: Colors.red,
            ),
          ],
        ),
      ),
    );

    return Column(
      children: [
        const SizedBox(height: 80),
        SelectableText(
          l10n.chooseYourCharacterTitleText,
          style: theme.textTheme.headline1
              ?.copyWith(color: PhotoboothColors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SelectableText(
          l10n.youCanChangeThemLaterSubheading,
          style: theme.textTheme.headline3
              ?.copyWith(color: PhotoboothColors.white),
          textAlign: TextAlign.center,
        ),
        Container(
          color: Colors.red,
          child: LayoutBuilder(
            builder: (_, constraints) {
              if (constraints.maxWidth <= PhotoboothBreakpoints.small) {
                return const CharacterSelector.small();
              } else if (constraints.maxWidth <= PhotoboothBreakpoints.medium) {
                return const CharacterSelector.medium();
              } else if (constraints.maxWidth <= PhotoboothBreakpoints.large) {
                return const CharacterSelector.large();
              } else {
                return const CharacterSelector.xLarge();
              }
            },
          ),
        ),
        const SizedBox(height: 42),
        FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(PhotoBoothPage.route());
          },
          child: const Icon(Icons.arrow_right),
        ),
      ],
    );
  }
}
