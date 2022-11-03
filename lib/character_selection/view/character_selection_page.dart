import 'package:flutter/material.dart';
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
    return const AppPageView(
      backgrounds: [
        CharacterSelectionBackground(),
        CharacterSelectionBackgroundOverlay()
      ],
      body: CharacterSelectionBody(),
      footer: SimplifiedFooter(),
    );
  }
}
