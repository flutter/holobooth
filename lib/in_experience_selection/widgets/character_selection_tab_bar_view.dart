import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class CharacterSelectionTabBarView extends StatelessWidget {
  const CharacterSelectionTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    final characterSelected = context
        .select((InExperienceSelectionBloc bloc) => bloc.state.character);
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 48),
          child: Text(
            l10n.charactersTabTitle,
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
  });

  final Character character;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: CircleAvatar(
        radius: 55,
        backgroundColor:
            isSelected ? PhotoboothColors.white : HoloBoothColors.darkBlue,
        child: CircleAvatar(
          radius: 50,
          backgroundColor: character.toBackgroundColor(),
          child: Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.hardEdge,
            color: Colors.transparent,
            child: InkWell(
              key: Key('characterSelectionElement_${character.name}'),
              child: SizedBox(
                height: 100,
                width: 100,
                child: character.toImage(),
              ),
              onTap: () {
                context
                    .read<InExperienceSelectionBloc>()
                    .add(InExperienceSelectionCharacterSelected(character));
              },
            ),
          ),
        ),
      ),
    );
  }
}
