import 'dart:math';

import 'package:flutter/material.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class CharacterSelectionBody extends StatelessWidget {
  const CharacterSelectionBody({super.key});

  // Minimum height calculated to avoid overlap in the stack
  static const _minBodyHeight = 600.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final size = MediaQuery.of(context).size;
    double bodyHeight;
    double viewportFraction;
    if (size.width <= PhotoboothBreakpoints.small) {
      bodyHeight = size.height * 0.6;
      viewportFraction = 0.55;
    } else if (size.width <= PhotoboothBreakpoints.medium) {
      bodyHeight = size.height * 0.6;
      viewportFraction = 0.35;
    } else {
      bodyHeight = size.height * 0.75;
      viewportFraction = 0.2;
    }
    bodyHeight = max(_minBodyHeight, bodyHeight);
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
                  viewPortFraction: viewportFraction,
                ),
              ),
              // Character selection
              Align(
                alignment: Alignment.bottomCenter,
                child: CharacterSelector(viewportFraction: viewportFraction),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
