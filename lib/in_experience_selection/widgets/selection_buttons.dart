import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          const InExperienceSelectionOptionUnselected(),
        );
    Navigator.of(context).pop();
  }

  void _showCharacterBottomSheet(BuildContext context) {
    ItemSelectorBottomSheet.show<Color>(
      context,
      key: characterSelectionBottomSheetKey,
      title: context.l10n.characterSelectorButton,
      items: const [Colors.red, Colors.yellow, Colors.green],
      itemBuilder: (context, item) => ColoredBox(color: item),
      selectedItem: Colors.red,
      onSelected: print,
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
          switch (state.drawerOption!) {
            case DrawerOption.characters:
              return _showCharacterBottomSheet(context);
            case DrawerOption.props:
              return _showPropsBottomSheet(context);
            case DrawerOption.backgrounds:
              return _showBackgroundBottomSheet(context);
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
                key: SelectionButtons.charactersSelectionButtonKey,
                title: context.l10n.characterSelectorButton,
                showTitle: screenSize >= PhotoboothBreakpoints.small,
                onTap: () => context.read<InExperienceSelectionBloc>().add(
                      const InExperienceSelectionOptionSelected(
                        drawerOption: DrawerOption.characters,
                      ),
                    ),
                child: const _CharacterSelectionButton(),
              ),
              spacer,
              ItemSelectorButton(
                key: SelectionButtons.propsSelectionButtonKey,
                title: context.l10n.propsSelectorButton,
                showTitle: screenSize >= PhotoboothBreakpoints.small,
                onTap: () => context.read<InExperienceSelectionBloc>().add(
                      const InExperienceSelectionOptionSelected(
                        drawerOption: DrawerOption.props,
                      ),
                    ),
                child: const _BackgroundSelectionButton(),
              ),
              spacer,
              ItemSelectorButton(
                key: SelectionButtons.backgroundSelectorButtonKey,
                title: context.l10n.backgroundSelectorButton,
                showTitle: screenSize >= PhotoboothBreakpoints.small,
                onTap: () => context.read<InExperienceSelectionBloc>().add(
                      const InExperienceSelectionOptionSelected(
                        drawerOption: DrawerOption.backgrounds,
                      ),
                    ),
                child: const _BackgroundSelectionButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackgroundSelectionButton extends StatelessWidget {
  const _BackgroundSelectionButton();

  @override
  Widget build(BuildContext context) {
    final backgroundSelected = context
        .select((InExperienceSelectionBloc bloc) => bloc.state.background);

    return _Button(imageProvider: backgroundSelected.toImageProvider());
  }
}

class _CharacterSelectionButton extends StatelessWidget {
  const _CharacterSelectionButton();

  @override
  Widget build(BuildContext context) {
    final characterSelected = context
        .select((InExperienceSelectionBloc bloc) => bloc.state.character);

    return _Button(
      imageProvider: characterSelected.toImageProvider(),
      backgroundColor: characterSelected.toBackgroundColor(),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.imageProvider,
    this.backgroundColor,
  });

  final ImageProvider imageProvider;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 55,
      backgroundColor: PhotoboothColors.white,
      child: CircleAvatar(
        foregroundImage: imageProvider,
        backgroundColor: backgroundColor,
        radius: 50,
      ),
    );
  }
}
