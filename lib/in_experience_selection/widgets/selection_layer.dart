import 'package:flutter/material.dart';
import 'package:holobooth/in_experience_selection/in_experience_selection.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

const _collapseButtonHeight = 50.0;
const _collapseButtonWidth = 100.0;
const _panelHeightCollapsed = 200.0;
const _panelHeightNotCollapsed = 350.0;

class SelectionLayer extends StatelessWidget {
  const SelectionLayer({super.key});

  @override
  Widget build(BuildContext context) {
    // Can not use LayoutBuilder because it takes whole space on Stack
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= HoloboothBreakpoints.small) {
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
        clipper: BlurryContainerClipPath(),
        child: BlurryContainer(
          color: HoloBoothColors.darkPurple.withOpacity(0.84),
          height: collapsed ? _panelHeightCollapsed : _panelHeightNotCollapsed,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: CollapseButton(
                  onPressed: () => setState(() => collapsed = !collapsed),
                  collapsed: collapsed,
                ),
              ),
              Flexible(child: PrimarySelectionView(collapsed: collapsed)),
            ],
          ),
        ),
      ),
    );
  }
}

@visibleForTesting
class CollapseButton extends StatelessWidget {
  const CollapseButton({
    super.key,
    required this.onPressed,
    required this.collapsed,
  });

  final VoidCallback onPressed;
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _collapseButtonWidth,
      height: _collapseButtonHeight,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          collapsed ? Icons.expand_less : Icons.expand_more,
          color: HoloBoothColors.white,
        ),
      ),
    );
  }
}

@visibleForTesting
class BlurryContainerClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final totalWidth = size.width;
    final totalHeight = size.height;
    const radius = Radius.circular(15);

    final path = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          Rect.fromPoints(
            const Offset(0, _collapseButtonHeight),
            Offset(totalWidth, totalHeight),
          ),
          topLeft: radius,
        ),
      )
      ..addRRect(
        RRect.fromRectAndCorners(
          Rect.fromPoints(
            Offset(totalWidth - _collapseButtonWidth, 0),
            Offset(totalWidth, _collapseButtonHeight),
          ),
          topLeft: radius,
          topRight: radius,
        ),
      );
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
