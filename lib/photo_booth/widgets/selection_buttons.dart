import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/drawer_selection/drawer_selection.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

// TODO(laura177): Add buttons for selecting character and props
class SelectionButtons extends StatelessWidget {
  const SelectionButtons({super.key});

  @visibleForTesting
  static const itemSelectorButtonKey = Key('itemSelector_background');
  @visibleForTesting
  static const propsSelectorKey = Key('itemSelector_props');

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DrawerSelectionBloc>();
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ItemSelectorButton(
            key: SelectionButtons.itemSelectorButtonKey,
            buttonBackground: const ColoredBox(color: Colors.red),
            title: context.l10n.backgroundSelectorButton,
            onTap: () {
              bloc.add(
                const DrawerSelectionOptionSelected(DrawerOption.backgrounds),
              );
            },
          ),
          ItemSelectorButton(
            key: SelectionButtons.propsSelectorKey,
            buttonBackground: const ColoredBox(color: Colors.red),
            title: 'Props',
            onTap: () {
              bloc.add(
                const DrawerSelectionOptionSelected(DrawerOption.props),
              );
            },
          ),
        ],
      ),
    );
  }
}
