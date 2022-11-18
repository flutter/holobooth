import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/drawer_selection/drawer_selection.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/props/props.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class SelectionButtons extends StatelessWidget {
  const SelectionButtons({super.key});

  @visibleForTesting
  static const charactersSelectionButtonKey = Key('itemSelector_characters');

  @visibleForTesting
  static const characterSelectionBottomSheetKey =
      Key('selectionButtons_characters_bottomSheet');

  @visibleForTesting
  static const propsSelectionButtonKey = Key('itemSelector_props');

  @visibleForTesting
  static const propsSelectionBottomSheetKey =
      Key('selectionButtons_props_bottomSheet');

  @visibleForTesting
  static const backgroundSelectorButtonKey = Key('itemSelector_background');

  @visibleForTesting
  static const backgroundSelectionBottomSheetKey =
      Key('selectionButtons_background_bottomSheet');

  void _closeSheet(BuildContext context) {
    context.read<DrawerSelectionBloc>().add(
          const DrawerSelectionUnselected(),
        );
    Navigator.of(context).pop();
  }

  void _showCharacterBottomSheet(BuildContext context) {
    ItemSelectorBottomSheet.show<Color>(
      context,
      key: characterSelectionBottomSheetKey,
      title: context.l10n.characterSelectorButton,
      items: const [Colors.red, Colors.yellow, Colors.green],
      itemBuilder: (context, item) => ColoredBox(color: item),
      selectedItem: Colors.red,
      onSelected: print,
    );
  }

  void _showPropsBottomSheet(BuildContext context) {
    final propSelected = context.read<PropsBloc>().state.selectedProps;
    ItemSelectorBottomSheet.show<Prop>(
      context,
      key: propsSelectionBottomSheetKey,
      title: context.l10n.propsSelectorButton,
      items: Prop.values,
      itemBuilder: (_, item) => ColoredBox(
        key: Key('${item.name}_propSelection'),
        color: PhotoboothColors.blue,
        child: Center(
          child: Text(
            item.name,
            style: Theme.of(context)
                .textTheme
                .button
                ?.copyWith(color: PhotoboothColors.white),
          ),
        ),
      ),
      selectedItem: propSelected.isEmpty ? null : propSelected.first,
      onSelected: (prop) {
        _closeSheet(context);
        context.read<PropsBloc>().add(PropsSelected(prop));
      },
    );
  }

  void _showBackgroundBottomSheet(BuildContext context) {
    ItemSelectorBottomSheet.show<Color>(
      context,
      key: backgroundSelectionBottomSheetKey,
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

    return BlocListener<DrawerSelectionBloc, DrawerSelectionState>(
      listenWhen: (previous, current) =>
          previous != current && current.drawerOption != null,
      listener: (context, state) {
        if (MediaQuery.of(context).size.width >= PhotoboothBreakpoints.small) {
          return Scaffold.of(context).openEndDrawer();
        } else {
          switch (state.drawerOption!) {
            case DrawerOption.characters:
              return _showCharacterBottomSheet(context);
            case DrawerOption.props:
              return _showPropsBottomSheet(context);
            case DrawerOption.backgrounds:
              return _showBackgroundBottomSheet(context);
          }
        }
      },
      child: Align(
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
              key: SelectionButtons.charactersSelectionButtonKey,
              buttonBackground: const ColoredBox(color: Colors.red),
              title: context.l10n.characterSelectorButton,
              showTitle: screenSize >= PhotoboothBreakpoints.small,
              onTap: () => context.read<DrawerSelectionBloc>().add(
                    const DrawerSelectionOptionSelected(
                      drawerOption: DrawerOption.characters,
                    ),
                  ),
            ),
            spacer,
            ItemSelectorButton(
              key: SelectionButtons.propsSelectionButtonKey,
              buttonBackground: const ColoredBox(color: Colors.red),
              title: context.l10n.propsSelectorButton,
              showTitle: screenSize >= PhotoboothBreakpoints.small,
              onTap: () => context.read<DrawerSelectionBloc>().add(
                    const DrawerSelectionOptionSelected(
                      drawerOption: DrawerOption.props,
                    ),
                  ),
            ),
            spacer,
            ItemSelectorButton(
              key: SelectionButtons.backgroundSelectorButtonKey,
              buttonBackground: const ColoredBox(color: Colors.red),
              title: context.l10n.backgroundSelectorButton,
              showTitle: screenSize >= PhotoboothBreakpoints.small,
              onTap: () => context.read<DrawerSelectionBloc>().add(
                    const DrawerSelectionOptionSelected(
                      drawerOption: DrawerOption.backgrounds,
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
