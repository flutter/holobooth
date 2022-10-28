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
  State<CharacterSelector> createState() => CharacterSelectorState();
}

@visibleForTesting
class CharacterSelectorState extends State<CharacterSelector> {
  late PageController pageController;
  int activePage = 0;

  static const dashKey = Key('characterSelector_dash');
  static const sparkyKey = Key('characterSelector_sparky');

  static final _characters = [
    Assets.characters.dash.image(),
    Assets.characters.sparky.image(),
  ];

  static const _characterKeys = [dashKey, sparkyKey];

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
    pageController = PageController(
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

  void _onTapCharacter(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: PageView.builder(
        itemCount: 2,
        controller: pageController,
        onPageChanged: (value) {
          setState(() {
            activePage = value;
          });
        },
        itemBuilder: (context, index) {
          final isActive = index == activePage;
          return InkWell(
            onTap: () => _onTapCharacter(index),
            key: _characterKeys[index],
            child: _Item(isActive: isActive, image: _characters[index]),
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
