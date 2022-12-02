import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class DrawerLayer extends StatelessWidget {
  const DrawerLayer({super.key});

  @visibleForTesting
  static const propsDrawerKey = Key('drawerLayer_props');

  @visibleForTesting
  static const backgroundsDrawerKey = Key('drawerLayer_backgrounds');

  @visibleForTesting
  static const charactersDrawerKey = Key('drawerLayer_characters');

  @visibleForTesting
  static const noOptionSelectedKey = Key('drawerLayer_noOptionSelected');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InExperienceSelectionBloc, InExperienceSelectionState>(
      builder: (context, state) {
        switch (state.drawerOption) {
          case null:
            return const SizedBox(
              key: noOptionSelectedKey,
            );
          case DrawerOption.props:
            return BlocSelector<InExperienceSelectionBloc,
                InExperienceSelectionState, List<Prop>>(
              selector: (state) => state.selectedProps,
              builder: (context, selectedProps) {
                return ItemSelectorDrawer<Prop>(
                  key: propsDrawerKey,
                  title: DrawerOption.props.localized(context),
                  items: Prop.values,
                  itemBuilder: (_, item) => InExperienceSelectionItem(
                    key: Key('${item.name}_propSelection'),
                    name: item.name,
                  ),
                  selectedItem:
                      selectedProps.isEmpty ? null : selectedProps.first,
                  onSelected: (prop) {
                    Navigator.of(context).pop();
                    context
                        .read<InExperienceSelectionBloc>()
                        .add(InExperienceSelectionPropSelected(prop));
                  },
                );
              },
            );
          case DrawerOption.backgrounds:
            return BlocSelector<InExperienceSelectionBloc,
                InExperienceSelectionState, Background>(
              selector: (state) => state.background,
              builder: (context, backgroundSelected) {
                return ItemSelectorDrawer<Background>(
                  key: backgroundsDrawerKey,
                  title: DrawerOption.backgrounds.localized(context),
                  items: Background.values,
                  itemBuilder: (_, item) => InExperienceSelectionItem(
                    key: Key('${item.name}_backgroundSelection'),
                    name: item.name,
                  ),
                  selectedItem: backgroundSelected,
                  onSelected: (background) {
                    Navigator.of(context).pop();
                    context.read<InExperienceSelectionBloc>().add(
                          InExperienceSelectionBackgroundSelected(background),
                        );
                  },
                );
              },
            );
          case DrawerOption.characters:
            return BlocSelector<InExperienceSelectionBloc,
                InExperienceSelectionState, Character>(
              selector: (state) => state.character,
              builder: (context, characterSelected) {
                return ItemSelectorDrawer<Character>(
                  key: charactersDrawerKey,
                  title: DrawerOption.characters.localized(context),
                  items: Character.values,
                  itemBuilder: (_, item) => InExperienceSelectionItem(
                    key: Key('${item.name}_characterSelection'),
                    name: item.name,
                  ),
                  selectedItem: characterSelected,
                  onSelected: (character) {
                    Navigator.of(context).pop();
                    context
                        .read<InExperienceSelectionBloc>()
                        .add(InExperienceSelectionCharacterSelected(character));
                  },
                );
              },
            );
        }
      },
    );
  }
}
