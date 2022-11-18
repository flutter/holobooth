import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/drawer_selection/bloc/drawer_selection_bloc.dart';
import 'package:io_photobooth/drawer_selection/drawer_option/drawer_option.dart';
import 'package:io_photobooth/props/bloc/props_bloc.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class DrawerLayer extends StatelessWidget {
  const DrawerLayer({super.key});

  @visibleForTesting
  static const propsDrawerKey = Key('drawerLayer_props');

  @visibleForTesting
  static const backgroundsDrawerKey = Key('drawerLayer_backgrounds');

  @visibleForTesting
  static const charactersDrawerKey = Key('drawerLayer_characters');

  @visibleForTesting
  static const noOptionSelectedKey = Key('drawerLayer_noOptionSelected');

  @override
  Widget build(BuildContext context) {
    final propSelected =
        context.select((PropsBloc bloc) => bloc.state.selectedProps);
    return BlocBuilder<DrawerSelectionBloc, DrawerSelectionState>(
      builder: (context, state) {
        switch (state.drawerOption) {
          case null:
            return const SizedBox(key: noOptionSelectedKey);
          case DrawerOption.props:
            return ItemSelectorDrawer<Prop>(
              key: propsDrawerKey,
              title: DrawerOption.props.localized(context),
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
                Navigator.of(context).pop();
                context.read<PropsBloc>().add(PropsSelected(prop));
              },
            );
          case DrawerOption.backgrounds:
            return ItemSelectorDrawer(
              key: backgroundsDrawerKey,
              title: DrawerOption.backgrounds.localized(context),
              items: const [
                PhotoboothColors.purple,
                PhotoboothColors.green,
                PhotoboothColors.blue
              ],
              itemBuilder: (_, item) => ColoredBox(
                color: item,
                key: Key('${item.value}_backgroundSelection'),
              ),
              selectedItem: PhotoboothColors.red,
              onSelected: (_) {
                Navigator.of(context).pop();
              },
            );
          case DrawerOption.characters:
            return ItemSelectorDrawer(
              key: charactersDrawerKey,
              title: DrawerOption.characters.localized(context),
              items: const [
                PhotoboothColors.orange,
                PhotoboothColors.green,
                PhotoboothColors.blue
              ],
              itemBuilder: (_, item) => ColoredBox(
                color: item,
                key: Key('${item.value}_characterSelection'),
              ),
              selectedItem: PhotoboothColors.red,
              onSelected: (prop) {
                Navigator.of(context).pop();
              },
            );
        }
      },
    );
  }
}
