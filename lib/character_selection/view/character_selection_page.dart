import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class CharacterSelectionPage extends StatelessWidget {
  const CharacterSelectionPage({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const CharacterSelectionPage());

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectACharacterTitleText),
        backgroundColor: PhotoboothColors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _CharacterSelections(),
            ActionChip(
              label: Text(l10n.toThePhotoBoothButtonText),
              backgroundColor: PhotoboothColors.blue,
              onPressed: () =>
                  Navigator.of(context).push<void>(PhotoboothPage.route()),
            )
          ],
        ),
      ),
    );
  }
}

class _CharacterSelections extends StatelessWidget {
  const _CharacterSelections();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      shrinkWrap: true,
      itemCount: 6,
      itemBuilder: (context, index) {
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
    );
  }
}
