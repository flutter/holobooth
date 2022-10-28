import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/drawer_selection/bloc/drawer_selection_bloc.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class DrawerLayer extends StatelessWidget {
  const DrawerLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DrawerSelectionBloc, DrawerSelectionState>(
      listener: (context, state) {
        if (state.drawerSelectionStatus ==
            DrawerSelectionStatus.shouldOpenBackgrounds) {
          Scaffold.of(context).openEndDrawer();
        }
      },
      builder: (context, state) {
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
      },
    );
  }
}
