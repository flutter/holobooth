import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/in_experience_selection/in_experience_selection.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class BackgroundSelectionTabBarView extends StatelessWidget {
  const BackgroundSelectionTabBarView({super.key});

  static const listviewKey = Key('background_listview');
  @visibleForTesting
  static Key backgroundSelectionKey(Background background) {
    return Key('backgroundSelectionElement_${background.name}');
  }

  @override
  Widget build(BuildContext context) {
    final backgroundSelected = context
        .select((InExperienceSelectionBloc bloc) => bloc.state.background);
    final l10n = context.l10n;
    final isSmall =
        MediaQuery.of(context).size.width <= HoloboothBreakpoints.small;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: isSmall ? 12 : 40),
          child: Text(
            l10n.backgroundsTabTitle,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: HoloBoothColors.white),
          ),
        ),
        Flexible(
          child: ListView.separated(
            key: listviewKey,
            scrollDirection: isSmall ? Axis.horizontal : Axis.vertical,
            itemCount: Background.values.length,
            itemBuilder: (context, index) {
              final background = Background.values[index];
              return Padding(
                padding: isSmall
                    ? const EdgeInsets.only(left: 16, top: 12, bottom: 12)
                    : const EdgeInsets.only(left: 60, right: 60, top: 5),
                child: AspectRatio(
                  aspectRatio: 120 / 80,
                  child: _BackgroundSelectionElement(
                    background: background,
                    isSelected: backgroundSelected == background,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox.square(
              dimension: 32,
            ),
          ),
        ),
      ],
    );
  }
}

class _BackgroundSelectionElement extends StatelessWidget {
  const _BackgroundSelectionElement({
    required this.background,
    required this.isSelected,
  });

  final Background background;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(12));
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isSelected ? null : HoloBoothColors.darkBlue,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        gradient: isSelected ? HoloBoothGradients.secondarySix : null,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          image: DecorationImage(
            image: background.thumbnailImageProvider(),
            fit: BoxFit.cover,
          ),
        ),
        child: Material(
          clipBehavior: Clip.hardEdge,
          shape: const RoundedRectangleBorder(),
          color: HoloBoothColors.transparent,
          child: InkWell(
            key: BackgroundSelectionTabBarView.backgroundSelectionKey(
              background,
            ),
            onTap: () {
              context
                  .read<InExperienceSelectionBloc>()
                  .add(InExperienceSelectionBackgroundSelected(background));
            },
          ),
        ),
      ),
    );
  }
}
