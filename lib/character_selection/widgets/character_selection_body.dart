import 'package:flutter/material.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class CharacterSelectionBody extends StatelessWidget {
  const CharacterSelectionBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final size = MediaQuery.of(context).size;
    double bodyHeight;
    double viewPortFraction;
    if (size.width <= PhotoboothBreakpoints.small) {
      bodyHeight = size.height * 0.6;
      viewPortFraction = 0.55;
    } else if (size.width <= PhotoboothBreakpoints.medium) {
      bodyHeight = size.height * 0.6;
      viewPortFraction = 0.3;
    } else {
      bodyHeight = size.height * 0.75;
      viewPortFraction = 0.2;
    }

    return Column(
      children: [
        SizedBox(
          height: bodyHeight,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 24),
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
                    ],
                  ),
                ),
              ),

              // Light shadow
              Align(
                alignment: Alignment.topCenter,
                child: CharacterSpotlight(
                  bodyHeight: bodyHeight,
                  viewPortFraction: viewPortFraction,
                ),
              ),
              // Character selection
              Align(
                alignment: Alignment.bottomCenter,
                child: LayoutBuilder(
                  builder: (_, constraints) {
                    if (constraints.maxWidth <= PhotoboothBreakpoints.small) {
                      return const CharacterSelector.small();
                    } else if (constraints.maxWidth <=
                        PhotoboothBreakpoints.medium) {
                      return const CharacterSelector.medium();
                    } else if (constraints.maxWidth <=
                        PhotoboothBreakpoints.large) {
                      return const CharacterSelector.large();
                    } else {
                      return const CharacterSelector.xLarge();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
