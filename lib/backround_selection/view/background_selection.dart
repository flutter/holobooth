import 'package:flutter/material.dart';
import 'package:io_photobooth/character_selection/view/character_selection_page.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class BackgroundSelectionPage extends StatelessWidget {
  const BackgroundSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.selectABackgroundTitleText)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _BackgroundSelections(),
            ActionChip(
              label: Text(l10n.nextButtonText),
              backgroundColor: const Color.fromARGB(255, 129, 147, 231),
              onPressed: () =>
                  Navigator.of(context).push(CharacterSelectionPage.route()),
            )
          ],
        ),
      ),
    );
  }
}

class _BackgroundSelections extends StatelessWidget {
  const _BackgroundSelections({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
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
                  'background $index',
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
