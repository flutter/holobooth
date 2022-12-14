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
      child: ClipPath(
        clipper: CustomClipPath(),
        child: BlurryContainer(
          color: HoloBoothColors.darkPurple.withOpacity(0.84),
          height: 450,
          padding: const EdgeInsets.only(top: 65, left: 15, right: 15),
          borderRadius: const BorderRadius.only(topRight: Radius.circular(15)),
          child: const PrimarySelectionView(),
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  static const heightCurve = 50.0;
  static const widthCurve = 100.0;
  @override
  Path getClip(Size size) {
    final path = Path();
    final totalWidth = size.width;
    final totalHeight = size.height;
    path
      ..moveTo(totalWidth, 0)
      ..lineTo(totalWidth - widthCurve, 0)
      ..lineTo(totalWidth - widthCurve, heightCurve)
      ..lineTo(0, heightCurve)
      ..lineTo(0, totalHeight)
      ..lineTo(totalWidth, totalHeight)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
