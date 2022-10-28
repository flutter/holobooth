import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

// TODO(laura177): Add buttons for selecting character and props
class SelectionButtons extends StatelessWidget {
  const SelectionButtons({super.key});

  @visibleForTesting
  static const itemSelectorButtonKey = Key('itemSelector_background');

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ItemSelectorButton(
        key: SelectionButtons.itemSelectorButtonKey,
        buttonBackground: const ColoredBox(color: Colors.red),
        title: context.l10n.backgroundSelectorButton,
        onTap: () {
          Scaffold.of(context).openEndDrawer();
        },
      ),
    );
  }
}
