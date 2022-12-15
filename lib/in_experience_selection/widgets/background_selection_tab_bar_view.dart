import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class BackgroundSelectionTabBarView extends StatelessWidget {
  const BackgroundSelectionTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundSelected = context
        .select((InExperienceSelectionBloc bloc) => bloc.state.background);
    final l10n = context.l10n;
    final isSmall =
        MediaQuery.of(context).size.width <= PhotoboothBreakpoints.small;
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
                ?.copyWith(color: PhotoboothColors.white),
          ),
        ),
        Flexible(
          child: ListView.separated(
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
    return InkWell(
      key: Key('backgroundSelectionElement_${background.name}'),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            strokeAlign: BorderSide.strokeAlignOutside,
            color:
                isSelected ? PhotoboothColors.white : HoloBoothColors.darkBlue,
            width: 4,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          image: DecorationImage(
            image: background.toImageProvider(),
            fit: BoxFit.cover,
          ),
        ),
        child: Text(
          background.name,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      onTap: () {
        context
            .read<InExperienceSelectionBloc>()
            .add(InExperienceSelectionBackgroundSelected(background));
      },
    );
  }
}
