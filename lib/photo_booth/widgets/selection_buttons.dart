import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/drawer_selection/bloc/drawer_selection_bloc.dart';
import 'package:io_photobooth/drawer_selection/drawer_option/drawer_option.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

// TODO(laura177): Add buttons for selecting character and props
class SelectionButtons extends StatelessWidget {
  const SelectionButtons({super.key});

  @visibleForTesting
  static const itemSelectorButtonKey = Key('itemSelector_background');

  void _showSelector(BuildContext context, DrawerOption drawerOption) {
    context.read<DrawerSelectionBloc>().add(
          DrawerSelectionOptionSelected(
            drawerOption: drawerOption,
          ),
        );
    if (MediaQuery.of(context).size.width >= PhotoboothBreakpoints.small) {
      return Scaffold.of(context).openEndDrawer();
    } else {
      switch (drawerOption) {
        case DrawerOption.characters:
          return _showCharacterBottomSheet(context);
        case DrawerOption.props:
          return _showPropsBottomSheet(context);
        case DrawerOption.backgrounds:
          return _showBackgroundBottomSheet(context);
      }
    }
  }

  void _showCharacterBottomSheet(BuildContext context) {
    ItemSelectorBottomSheet.show<Color>(
      context,
      title: context.l10n.characterSelectorButton,
      items: const [Colors.red, Colors.yellow, Colors.green],
      itemBuilder: (context, item) => ColoredBox(color: item),
      selectedItem: Colors.red,
      onSelected: print,
    );
  }

  void _showPropsBottomSheet(BuildContext context) {
    ItemSelectorBottomSheet.show<Color>(
      context,
      title: context.l10n.propsSelectorButton,
      items: const [Colors.red, Colors.yellow, Colors.green],
      itemBuilder: (context, item) => ColoredBox(color: item),
      selectedItem: Colors.red,
      onSelected: print,
    );
  }

  void _showBackgroundBottomSheet(BuildContext context) {
    ItemSelectorBottomSheet.show<Color>(
      context,
      title: context.l10n.backgroundSelectorButton,
      items: const [Colors.red, Colors.yellow, Colors.green],
      itemBuilder: (context, item) => ColoredBox(color: item),
      selectedItem: Colors.red,
      onSelected: print,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.width;
    final spacer = SizedBox(
      width: screenSize >= PhotoboothBreakpoints.small ? 0 : 24,
      height: screenSize >= PhotoboothBreakpoints.small ? 48 : 0,
    );

    return Align(
      alignment: screenSize >= PhotoboothBreakpoints.small
          ? Alignment.centerRight
          : Alignment.topCenter,
      child: Flex(
        mainAxisSize: MainAxisSize.min,
        direction: screenSize >= PhotoboothBreakpoints.small
            ? Axis.vertical
            : Axis.horizontal,
        children: [
          ItemSelectorButton(
            buttonBackground: const ColoredBox(color: Colors.red),
            title: context.l10n.characterSelectorButton,
            showTitle: screenSize >= PhotoboothBreakpoints.small,
            onTap: () => _showSelector(context, DrawerOption.characters),
          ),
          spacer,
          ItemSelectorButton(
            buttonBackground: const ColoredBox(color: Colors.red),
            title: context.l10n.propsSelectorButton,
            showTitle: screenSize >= PhotoboothBreakpoints.small,
            onTap: () => _showSelector(context, DrawerOption.props),
          ),
          spacer,
          ItemSelectorButton(
            key: SelectionButtons.itemSelectorButtonKey,
            buttonBackground: const ColoredBox(color: Colors.red),
            title: context.l10n.backgroundSelectorButton,
            showTitle: screenSize >= PhotoboothBreakpoints.small,
            onTap: () => _showSelector(context, DrawerOption.backgrounds),
          ),
        ],
      ),
    );
  }
}
