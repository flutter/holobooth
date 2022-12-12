import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class BackgroundSelectionTabBarView extends StatelessWidget {
  const BackgroundSelectionTabBarView({super.key, required this.onNextPressed});

  final VoidCallback onNextPressed;

  @override
  Widget build(BuildContext context) {
    final backgroundSelected = context
        .select((InExperienceSelectionBloc bloc) => bloc.state.background);
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 24),
          child: Text(
            l10n.backgroundsTabTitle,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: PhotoboothColors.white),
          ),
        ),
        Flexible(
          child: ListView.builder(
            itemCount: Background.values.length,
            itemBuilder: (context, index) {
              final background = Background.values[index];
              return _BackgroundSelectionElement(
                background: background,
                isSelected: backgroundSelected == background,
              );
            },
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
        height: 90,
        width: 100,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 54, vertical: 24),
        decoration: BoxDecoration(
          border: Border.all(
            strokeAlign: BorderSide.strokeAlignOutside,
            color:
                isSelected ? PhotoboothColors.white : HoloBoothColors.darkBlue,
            width: 4,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
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
