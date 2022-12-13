import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class CharacterSelectionTabBarView extends StatelessWidget {
  const CharacterSelectionTabBarView({super.key, required this.onNextPressed});

  final VoidCallback onNextPressed;

  @override
  Widget build(BuildContext context) {
    final characterSelected = context
        .select((InExperienceSelectionBloc bloc) => bloc.state.character);
    final l10n = context.l10n;
    final isPortrait =
        MediaQuery.of(context).size.width <= PhotoboothBreakpoints.small;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Text(
            l10n.charactersTabTitle,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: PhotoboothColors.white),
          ),
        ),
        Expanded(
          child: Wrap(
            direction: isPortrait ? Axis.horizontal : Axis.vertical,
            spacing: 24,
            runSpacing: 1,
            children: [
              for (var i = 0; i < Character.values.length; i++)
                _CharacterSelectionElement(
                  character: Character.values[i],
                  isSelected: characterSelected == Character.values[i],
                )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: NextButton(onNextPressed: onNextPressed),
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
