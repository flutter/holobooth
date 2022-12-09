import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
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
    final characterSelected = context
        .select((InExperienceSelectionBloc bloc) => bloc.state.character);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 48),
          child: Text(
            'Characters',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: PhotoboothColors.white),
          ),
        ),
        Flexible(
          child: ListView.builder(
            itemCount: Character.values.length,
            itemBuilder: (context, index) {
              final character = Character.values[index];
              return _CharacterSelectionElement(
                character: character,
                isSelected: characterSelected == character,
                onSelected: (_) {
                  context
                      .read<InExperienceSelectionBloc>()
                      .add(InExperienceSelectionCharacterSelected(character));
                },
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: CircleAvatar(
        radius: 55,
        backgroundColor:
            isSelected ? PhotoboothColors.white : const Color(0xff061A4A),
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
  }
}
