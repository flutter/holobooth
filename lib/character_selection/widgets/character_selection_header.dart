import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class CharacterSelectionHeader extends StatelessWidget {
  const CharacterSelectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          SelectableText(
            l10n.chooseYourCharacterTitleText,
            style: theme.textTheme.displayLarge
                ?.copyWith(color: PhotoboothColors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SelectableText(
            l10n.youCanChangeThemLaterSubheading,
            style: theme.textTheme.displaySmall
                ?.copyWith(color: PhotoboothColors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
