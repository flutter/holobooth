import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

// TODO(laura177): Add buttons for selecting character and props
class SelectionButtons extends StatelessWidget {
  const SelectionButtons({super.key});

  @visibleForTesting
  static const itemSelectorButtonKey =
      Key('multipleCapturePage_itemSelector_background');

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.width;

    return Align(
      alignment: screenSize >= PhotoboothBreakpoints.small
          ? Alignment.centerRight
          : Alignment.topCenter,
      child: ItemSelectorButton(
        key: SelectionButtons.itemSelectorButtonKey,
        buttonBackground: const ColoredBox(color: Colors.red),
        title: context.l10n.backgroundSelectorButton,
        onTap: () {
          if (MediaQuery.of(context).size.width >=
              PhotoboothBreakpoints.small) {
            return Scaffold.of(context).openEndDrawer();
          } else {
            // TODO(laura177): replace contents of bottom sheet
            ItemSelectorBottomSheet.show<Color>(
              context,
              title: 'title',
              items: const [Colors.red, Colors.yellow, Colors.green],
              itemBuilder: (context, item) => ColoredBox(color: item),
              selectedItem: Colors.red,
              onSelected: print,
            );
          }
        },
      ),
    );
  }
}
