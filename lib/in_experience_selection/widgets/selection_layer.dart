import 'package:flutter/material.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

const _heightCurve = 50.0;
const _widthCurve = 100.0;
const collapseButtonSize = Size(_widthCurve, _heightCurve);
const _panelHeightCollapsed = 200.0;
const _panelHeightNotCollapsed = 350.0;

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
        child: const PrimarySelectionView(),
      ),
    );
  }
}

class MobileSelectionLayer extends StatefulWidget {
  const MobileSelectionLayer({super.key});

  @override
  State<MobileSelectionLayer> createState() => _MobileSelectionLayerState();
}

class _MobileSelectionLayerState extends State<MobileSelectionLayer> {
  bool collapsed = false;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      left: 0,
      bottom: 0,
      child: ClipPath(
        clipper: CustomClipPath(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: collapsed ? _panelHeightCollapsed : _panelHeightNotCollapsed,
          child: BlurryContainer(
            color: HoloBoothColors.darkPurple.withOpacity(0.84),
            borderRadius:
                const BorderRadius.only(topRight: Radius.circular(15)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 100,
                    height: 50,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          collapsed = !collapsed;
                        });
                      },
                      icon: const Icon(
                        Icons.expand_more,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Center(
                    child: PrimarySelectionView(
                      collapsed: collapsed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final totalWidth = size.width;
    final totalHeight = size.height;
    path
      ..moveTo(totalWidth, 0)
      ..lineTo(totalWidth - _widthCurve, 0)
      ..lineTo(totalWidth - _widthCurve, _heightCurve)
      ..lineTo(0, _heightCurve)
      ..lineTo(0, totalHeight)
      ..lineTo(totalWidth, totalHeight)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
