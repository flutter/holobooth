import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/multiple_capture/multiple_capture.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class CharacterSelectionPage extends StatelessWidget {
  const CharacterSelectionPage({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const CharacterSelectionPage());

  @override
  Widget build(BuildContext context) {
    return const CharacterSelectionView();
  }
}

@visibleForTesting
class CharacterSelectionView extends StatelessWidget {
  const CharacterSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectACharacterTitleText),
        backgroundColor: PhotoboothColors.blue,
      ),
      body: CustomScrollView(
        slivers: [
          const CharacterSelections(),
          SliverToBoxAdapter(
            child: ActionChip(
              label: Text(l10n.toThePhotoBoothButtonText),
              backgroundColor: PhotoboothColors.blue,
              onPressed: () =>
                  Navigator.of(context).push<void>(MultipleCapturePage.route()),
            ),
          ),
        ],
      ),
    );
  }
}

@visibleForTesting
class CharacterSelections extends StatelessWidget {
  const CharacterSelections({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Character $index',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
        childCount: 6,
      ),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
    );
  }
}
