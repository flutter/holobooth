import 'package:flutter/material.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class SelectionLayer extends StatelessWidget {
  const SelectionLayer({super.key});

  @override
  Widget build(BuildContext context) {
    // Can not use LayoutBuilder because it takes whole space on Stack
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= PhotoboothBreakpoints.small) {
      return const MobileSelectionLayer();
    }
    return const DesktopSelectionLayer();
  }
}

class DesktopSelectionLayer extends StatelessWidget {
  const DesktopSelectionLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      child: Container(
        color: PhotoboothColors.black,
        width: 300,
        child: PrimarySelectionView(onTabChanged: (_) {}),
      ),
    );
  }
}

class MobileSelectionLayer extends StatelessWidget {
  const MobileSelectionLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PhotoboothColors.red,
      width: 300,
      height: 100,
    );
  }
}
