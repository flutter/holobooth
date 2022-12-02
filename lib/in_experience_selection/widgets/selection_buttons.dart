import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class SelectionButtons extends StatelessWidget {
  const SelectionButtons({super.key});

  @visibleForTesting
  static const charactersSelectionButtonKey = Key('itemSelector_characters');

  @visibleForTesting
  static const characterSelectionBottomSheetKey =
      Key('selectionButtons_characters_bottomSheet');

  @visibleForTesting
  static const propsSelectionButtonKey = Key('itemSelector_props');

  @visibleForTesting
  static const propsSelectionBottomSheetKey =
      Key('selectionButtons_props_bottomSheet');

  @visibleForTesting
  static const backgroundSelectorButtonKey = Key('itemSelector_background');

  @visibleForTesting
  static const backgroundSelectionBottomSheetKey =
      Key('selectionButtons_background_bottomSheet');

  void _closeSheet(BuildContext context) {
    context.read<InExperienceSelectionBloc>().add(
          const InExperienceSelectionOptionSelected(),
        );
    Navigator.of(context).pop();
  }

  void _showCharacterBottomSheet(BuildContext context) {
    final characterSelected =
        context.read<InExperienceSelectionBloc>().state.character;
    ItemSelectorBottomSheet.show<Character>(
      context,
      key: characterSelectionBottomSheetKey,
      title: context.l10n.characterSelectorButton,
      items: Character.values,
      itemBuilder: (_, item) => InExperienceSelectionItem(
        key: Key('${item.name}_characterSelection'),
        name: item.name,
      ),
      selectedItem: characterSelected,
      onSelected: (character) {
        _closeSheet(context);
        context
            .read<InExperienceSelectionBloc>()
            .add(InExperienceSelectionCharacterSelected(character));
      },
    );
  }

  void _showPropsBottomSheet(BuildContext context) {
    final propSelected =
        context.read<InExperienceSelectionBloc>().state.selectedProps;
    ItemSelectorBottomSheet.show<Prop>(
      context,
      key: propsSelectionBottomSheetKey,
      title: context.l10n.propsSelectorButton,
      items: Prop.values,
      itemBuilder: (_, item) => InExperienceSelectionItem(
        key: Key('${item.name}_propSelection'),
        name: item.name,
      ),
      selectedItem: propSelected.isEmpty ? null : propSelected.first,
      onSelected: (prop) {
        _closeSheet(context);
        context
            .read<InExperienceSelectionBloc>()
            .add(InExperienceSelectionPropSelected(prop));
      },
    );
  }

  void _showBackgroundBottomSheet(BuildContext context) {
    final backgroundSelected =
        context.read<InExperienceSelectionBloc>().state.background;
    ItemSelectorBottomSheet.show<Background>(
      context,
      key: backgroundSelectionBottomSheetKey,
      title: context.l10n.backgroundSelectorButton,
      items: Background.values,
      itemBuilder: (_, item) => InExperienceSelectionItem(
        key: Key('${item.name}_backgroundSelection'),
        name: item.name,
      ),
      selectedItem: backgroundSelected,
      onSelected: (background) {
        _closeSheet(context);
        context
            .read<InExperienceSelectionBloc>()
            .add(InExperienceSelectionBackgroundSelected(background));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.width;
    final spacer = SizedBox(
      width: screenSize >= PhotoboothBreakpoints.small ? 0 : 24,
      height: screenSize >= PhotoboothBreakpoints.small ? 48 : 0,
    );

    return BlocListener<InExperienceSelectionBloc, InExperienceSelectionState>(
      listenWhen: (previous, current) =>
          previous != current && current.drawerOption != null,
      listener: (context, state) {
        if (MediaQuery.of(context).size.width >= PhotoboothBreakpoints.small) {
          return Scaffold.of(context).openEndDrawer();
        } else {
          switch (state.drawerOption) {
            case DrawerOption.characters:
              return _showCharacterBottomSheet(context);
            case DrawerOption.props:
              return _showPropsBottomSheet(context);
            case DrawerOption.backgrounds:
              return _showBackgroundBottomSheet(context);
            // It will not happen ever
            // ignore: no_default_cases
            default:
              break;
          }
        }
      },
      child: Align(
        alignment: screenSize >= PhotoboothBreakpoints.small
            ? Alignment.centerRight
            : Alignment.topCenter,
        child: SingleChildScrollView(
          child: Flex(
            mainAxisSize: MainAxisSize.min,
            direction: screenSize >= PhotoboothBreakpoints.small
                ? Axis.vertical
                : Axis.horizontal,
            children: [
              ItemSelectorButton(
                title: context.l10n.characterSelectorButton,
                showTitle: screenSize >= PhotoboothBreakpoints.small,
                child: const _CharacterSelectionButton(
                  key: SelectionButtons.charactersSelectionButtonKey,
                ),
              ),
              spacer,
              ItemSelectorButton(
                title: context.l10n.propsSelectorButton,
                showTitle: screenSize >= PhotoboothBreakpoints.small,
                child: const _PropsSelectionButton(
                  key: SelectionButtons.propsSelectionButtonKey,
                ),
              ),
              spacer,
              ItemSelectorButton(
                title: context.l10n.backgroundSelectorButton,
                showTitle: screenSize >= PhotoboothBreakpoints.small,
                child: const _BackgroundSelectionButton(
                  key: SelectionButtons.backgroundSelectorButtonKey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackgroundSelectionButton extends StatelessWidget {
  const _BackgroundSelectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundSelected = context
        .select((InExperienceSelectionBloc bloc) => bloc.state.background);

    return _Button(
      imageProvider: backgroundSelected.toImageProvider(),
      onTap: () => context.read<InExperienceSelectionBloc>().add(
            const InExperienceSelectionOptionSelected(
              drawerOption: DrawerOption.backgrounds,
            ),
          ),
    );
  }
}

class _CharacterSelectionButton extends StatelessWidget {
  const _CharacterSelectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final characterSelected = context
        .select((InExperienceSelectionBloc bloc) => bloc.state.character);

    return _Button(
      imageProvider: characterSelected.toImageProvider(),
      backgroundColor: characterSelected.toBackgroundColor(),
      onTap: () => context.read<InExperienceSelectionBloc>().add(
            const InExperienceSelectionOptionSelected(
              drawerOption: DrawerOption.characters,
            ),
          ),
    );
  }
}

class _PropsSelectionButton extends StatelessWidget {
  const _PropsSelectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final propsSelected = context
        .select((InExperienceSelectionBloc bloc) => bloc.state.selectedProps);
    ImageProvider? imageProvider;
    Widget? child;
    Color backgroundColor;
    if (propsSelected.isEmpty) {
      backgroundColor = PhotoboothColors.green;
      child = const Icon(
        Icons.add,
        color: PhotoboothColors.white,
        size: 40,
      );
    } else if (propsSelected.length == 1) {
      backgroundColor = PhotoboothColors.white;
      imageProvider = propsSelected.first.toImageProvider();
    } else {
      backgroundColor = PhotoboothColors.blue;
      child = Center(
        child: Text(
          propsSelected.length.toString(),
          style: Theme.of(context)
              .textTheme
              .displayLarge
              ?.copyWith(color: PhotoboothColors.white),
        ),
      );
    }

    return _Button(
      imageProvider: imageProvider,
      backgroundColor: backgroundColor,
      onTap: () => context.read<InExperienceSelectionBloc>().add(
            const InExperienceSelectionOptionSelected(
              drawerOption: DrawerOption.props,
            ),
          ),
      child: child,
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.imageProvider,
    this.backgroundColor,
    required this.onTap,
    this.child,
  });

  final ImageProvider? imageProvider;
  final Color? backgroundColor;
  final VoidCallback onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 38,
      backgroundColor: PhotoboothColors.white,
      child: CircleAvatar(
        radius: 34,
        backgroundImage: imageProvider,
        backgroundColor: backgroundColor,
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: child,
          ),
        ),
      ),
    );
  }
}
