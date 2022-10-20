import 'package:flutter/material.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class BackgroundSelectionPage extends StatelessWidget {
  const BackgroundSelectionPage({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const BackgroundSelectionPage());

  @override
  Widget build(BuildContext context) {
    return const BackgroundSelectionView();
  }
}

@visibleForTesting
class BackgroundSelectionView extends StatelessWidget {
  const BackgroundSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectABackgroundTitleText),
        backgroundColor: PhotoboothColors.blue,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ColoredBox(
              color: Colors.black,
              child: ItemSelectorButton(
                buttonBackground: const ColoredBox(color: Colors.red),
                title: 'Title',
                onTap: () => {},
              ),
            ),
          ),
          const BackgroundSelections(),
          SliverToBoxAdapter(
            child: ActionChip(
              label: Text(l10n.nextButtonText),
              backgroundColor: PhotoboothColors.blue,
              onPressed: () {
                Navigator.of(context).push(CharacterSelectionPage.route());
              },
            ),
          )
        ],
      ),
    );
  }
}

@visibleForTesting
class BackgroundSelections extends StatelessWidget {
  const BackgroundSelections({super.key});

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
                    'background $index',
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
