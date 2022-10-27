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
        viewportFraction = 0.55;
        break;
      case Breakpoint.medium:
        viewportFraction = 0.3;
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
                curve: Curves.easeInOut,
              );
            },
            child: _Item(
              isActive: isActive,
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
    required this.image,
  });

  final bool isActive;
  final Image image;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isActive ? 1 : 0.70,
      duration: const Duration(milliseconds: 300),
      child: image,
    );
  }
}
