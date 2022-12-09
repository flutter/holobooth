import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:io_photobooth/in_experience_selection/options/character.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class CharacterSelectionTabBarView extends StatelessWidget {
  const CharacterSelectionTabBarView({super.key});

  static const _defaultGridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 150,
    mainAxisSpacing: 64,
    crossAxisSpacing: 42,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Characters',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: PhotoboothColors.white),
        ),
        Flexible(
          child: GridView.builder(
            key: PageStorageKey<String>('$key'),
            gridDelegate: _defaultGridDelegate,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
            itemCount: Character.values.length,
            itemBuilder: (context, index) {
              final character = Character.values[index];
              return _CharacterSelectionElement(
                character: character,
                isSelected: false,
                onSelected: (_) {},
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CharacterSelectionElement extends StatelessWidget {
  const _CharacterSelectionElement({
    required this.character,
    required this.isSelected,
    required this.onSelected,
  });

  final Character character;
  final bool isSelected;
  final ValueSetter<Character> onSelected;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: isSelected ? PhotoboothColors.white : Color(0xff061A4A),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: CircleAvatar(
          radius: 50,
          backgroundColor: character.toBackgroundColor(),
          child: Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.hardEdge,
            color: Colors.transparent,
            child: InkWell(
              child: character.toImage(),
              onTap: () {
                onSelected(character);
              },
            ),
          ),
        ),
      ),
    );
    return CircleAvatar(
      radius: 38,
      backgroundColor: PhotoboothColors.white,
      child: CircleAvatar(
        radius: 36,
        backgroundImage: Assets.characters.dash.provider(),
        backgroundColor: PhotoboothColors.blue,
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              onSelected(character);
            },
            child: const SizedBox(),
          ),
        ),
      ),
    );
  }
}
