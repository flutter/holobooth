import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/drawer_selection/bloc/drawer_selection_bloc.dart';
import 'package:io_photobooth/drawer_selection/drawer_option/drawer_option.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class DrawerLayer extends StatelessWidget {
  const DrawerLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawerSelectionBloc, DrawerSelectionState>(
      builder: (context, state) {
        switch (state.drawerOption) {
          case DrawerOption.props:
            return ItemSelectorDrawer(
              title: DrawerOption.props.localized(context),
              items: const [
                PhotoboothColors.red,
                PhotoboothColors.green,
                PhotoboothColors.blue
              ],
              itemBuilder: (_, item) => ColoredBox(color: item),
              selectedItem: PhotoboothColors.red,
              onSelected: print,
            );
          case DrawerOption.backgrounds:
            return ItemSelectorDrawer(
              title: DrawerOption.backgrounds.localized(context),
              items: const [
                PhotoboothColors.purple,
                PhotoboothColors.green,
                PhotoboothColors.blue
              ],
              itemBuilder: (_, item) => ColoredBox(color: item),
              selectedItem: PhotoboothColors.red,
              onSelected: print,
            );
          case DrawerOption.characters:
            return ItemSelectorDrawer(
              title: DrawerOption.characters.localized(context),
              items: const [
                PhotoboothColors.orange,
                PhotoboothColors.green,
                PhotoboothColors.blue
              ],
              itemBuilder: (_, item) => ColoredBox(color: item),
              selectedItem: PhotoboothColors.red,
              onSelected: print,
            );
          case null:
            return const SizedBox();
        }
      },
    );
  }
}
