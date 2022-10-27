import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';

enum Breakpoint {
  small,
  medium,
  large,
  xLarge,
}

class CharacterSelector extends StatefulWidget {
  const CharacterSelector({super.key, required this.breakpoint});

  final Breakpoint breakpoint;

  @override
  State<CharacterSelector> createState() => _CharacterSelectorState();
}

class _CharacterSelectorState extends State<CharacterSelector> {
  late PageController _pageController;
  int activePage = 0;

  void _initController() {
    double viewportFraction;
    switch (widget.breakpoint) {
      case Breakpoint.small:
        viewportFraction = 0.45;
        break;
      case Breakpoint.medium:
        viewportFraction = 0.35;
        break;
      case Breakpoint.large:
        viewportFraction = 0.2;
        break;
      case Breakpoint.xLarge:
        viewportFraction = 0.2;
        break;
    }
    _pageController = PageController(
      viewportFraction: viewportFraction,
      initialPage: activePage,
    );
  }

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(covariant CharacterSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initController();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: PageView.builder(
        itemCount: 2,
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            activePage = value;
          });
        },
        itemBuilder: (context, index) {
          final isActive = index == activePage;
          return InkWell(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutQuint,
              );
            },
            child: _Item(
              isActive: isActive,
              breakpoint: widget.breakpoint,
              image: index == 0
                  ? Assets.characters.dash.image()
                  : Assets.characters.sparky.image(),
            ),
          );
        },
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.isActive,
    required this.breakpoint,
    required this.image,
  });

  final bool isActive;
  final Breakpoint breakpoint;
  final Image image;

  @override
  Widget build(BuildContext context) {
    double topBottomMargin;
    double topBottomPadding;
    switch (breakpoint) {
      case Breakpoint.small:
        topBottomMargin = isActive ? 50.0 : 120.0;
        topBottomPadding = isActive ? 0 : 130;
        break;
      case Breakpoint.medium:
        topBottomMargin = isActive ? 50.0 : 100.0;
        topBottomPadding = isActive ? 0 : 100;
        break;
      case Breakpoint.large:
        topBottomMargin = isActive ? 50.0 : 150.0;
        topBottomPadding = isActive ? 0 : 40;
        break;
      case Breakpoint.xLarge:
        topBottomMargin = isActive ? 50.0 : 150.0;
        topBottomPadding = isActive ? 0 : 15;
        break;
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(
        bottom: topBottomMargin,
        top: topBottomMargin,
        right: 30,
      ),
      padding: EdgeInsets.only(
        bottom: topBottomPadding,
        top: topBottomPadding,
      ),
      child: image,
    );
  }
}
