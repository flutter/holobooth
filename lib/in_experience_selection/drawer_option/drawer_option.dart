import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';

enum DrawerOption { props, backgrounds, characters }

extension LocalizedDrawerOption on DrawerOption {
  String localized(BuildContext context) {
    final l10n = context.l10n;

    switch (this) {
      case DrawerOption.props:
        return l10n.propsSelectorButton;
      case DrawerOption.backgrounds:
        return l10n.backgroundSelectorButton;
      case DrawerOption.characters:
        return l10n.characterSelectorButton;
    }
  }
}
