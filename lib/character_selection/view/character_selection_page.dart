import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class CharacterSelectionPage extends StatelessWidget {
  const CharacterSelectionPage({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const CharacterSelectionPage());

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: PhotoboothColors.white,
      body: CharacterSelectionView(),
    );
  }
}

@visibleForTesting
class CharacterSelectionView extends StatelessWidget {
  const CharacterSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageView(
      background: CharacterSelectionBackground(),
      background1: CharacterSelectionBackground1(),
      body: CharacterSelectionBody(),
      footer: SimplifiedFooter(),
    );
  }
}

class LightOverlay extends StatelessWidget {
  const LightOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (p0, constraints) {
        double widthFactor;
        if (constraints.maxWidth <= PhotoboothBreakpoints.small) {
          widthFactor = 0.6;
        } else if (constraints.maxWidth <= PhotoboothBreakpoints.medium) {
          widthFactor = 0.6;
        } else {
          widthFactor = 0.35;
        }
        return Align(
          alignment: Alignment.topCenter,
          child: Opacity(
            opacity: 0.5,
            child: Assets.backgrounds.lightEffectBackground
                .image(width: constraints.maxWidth * widthFactor),
          ),
        );
      },
    );
  }
}
