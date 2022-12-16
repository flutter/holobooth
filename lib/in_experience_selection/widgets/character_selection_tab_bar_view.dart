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
    final isSmall =
        MediaQuery.of(context).size.width <= PhotoboothBreakpoints.small;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: isSmall ? 16 : 40),
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
            direction: isSmall ? Axis.horizontal : Axis.vertical,
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
    return Container(
      width: 100,
      height: 100,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? null : HoloBoothColors.darkBlue,
        gradient: isSelected
            ? const LinearGradient(
                colors: [
                  HoloBoothColors.gradientSecondaryOne,
                  HoloBoothColors.gradientSecondaryTwo,
                ],
              )
            : null,
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: PhotoboothColors.transparent,
        ),
        child: Material(
          clipBehavior: Clip.hardEdge,
          color: character.toBackgroundColor(),
          shape: const CircleBorder(),
          child: InkWell(
              key: Key('characterSelectionElement_${character.name}'),
              onTap: () {
                context
                    .read<InExperienceSelectionBloc>()
                    .add(InExperienceSelectionCharacterSelected(character));
              },
              child: character.toImage()),
        ),
      ),
    );
  }
}
