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
      right: 30,
      top: 60,
      bottom: 100,
      child: BlurryContainer(
        width: 300,
        borderRadius: BorderRadius.circular(24),
        color: HoloBoothColors.darkPurple.withOpacity(0.84),
        padding: const EdgeInsets.all(15),
        child: const PrimarySelectionView(),
      ),
    );
  }
}

class MobileSelectionLayer extends StatelessWidget {
  const MobileSelectionLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      left: 0,
      bottom: 0,
      child: SizedBox(
        height: 400,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: BlurryContainer(
                height: 50,
                width: 100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                color: HoloBoothColors.darkPurple.withOpacity(0.84),
                child: const SizedBox(
                  width: 50,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BlurryContainer(
                height: 350,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                ),
                color: HoloBoothColors.darkPurple.withOpacity(0.84),
                padding: const EdgeInsets.all(15),
                child: const PrimarySelectionView(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
