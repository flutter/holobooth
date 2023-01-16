import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/in_experience_selection/in_experience_selection.dart';

class GlassesSelectionTabBarView extends StatelessWidget {
  const GlassesSelectionTabBarView({super.key});

  @visibleForTesting
  static Key glassesSelectionKey(Glasses item) {
    return Key('glasses_selection_${item.name}');
  }

  @override
  Widget build(BuildContext context) {
    final selectedGlasses =
        context.select((InExperienceSelectionBloc bloc) => bloc.state.glasses);
    const items = Glasses.values;
    return PropsScrollView(
      itemBuilder: (context, index) {
        final item = items[index];
        return PropSelectionElement(
          key: glassesSelectionKey(item),
          onTap: () {
            context
                .read<InExperienceSelectionBloc>()
                .add(InExperienceSelectionGlassesToggled(item));
          },
          name: item.name,
          isSelected: item == selectedGlasses,
          imageProvider: item.toImageProvider(),
        );
      },
      itemCount: items.length,
    );
  }
}
