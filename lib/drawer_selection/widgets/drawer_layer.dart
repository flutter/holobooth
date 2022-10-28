import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/drawer_selection/bloc/drawer_selection_bloc.dart';
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
              title: 'Props',
              items: const [
                PhotoboothColors.red,
                PhotoboothColors.green,
                PhotoboothColors.blue
              ],
              itemBuilder: (context, item) => ColoredBox(color: item),
              selectedItem: PhotoboothColors.red,
              onSelected: (value) => print,
            );
          case DrawerOption.backgrounds:
            return ItemSelectorDrawer(
              title: 'Background',
              items: const [
                PhotoboothColors.red,
                PhotoboothColors.green,
                PhotoboothColors.blue
              ],
              itemBuilder: (context, item) => ColoredBox(color: item),
              selectedItem: PhotoboothColors.red,
              onSelected: (value) => print,
            );
          case DrawerOption.character:
            return ItemSelectorDrawer(
              title: 'Characters',
              items: const [
                PhotoboothColors.red,
                PhotoboothColors.green,
                PhotoboothColors.blue
              ],
              itemBuilder: (context, item) => ColoredBox(color: item),
              selectedItem: PhotoboothColors.red,
              onSelected: (value) => print,
            );
          case null:
            return const SizedBox();
        }
      },
    );
  }
}
