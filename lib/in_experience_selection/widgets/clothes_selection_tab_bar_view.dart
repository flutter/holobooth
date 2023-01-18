import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/in_experience_selection/in_experience_selection.dart';

class ClothesSelectionTabBarView extends StatelessWidget {
  const ClothesSelectionTabBarView({super.key});

  @visibleForTesting
  static Key clothesSelectionKey(Clothes item) {
    return Key('clothes_selection_${item.name}');
  }

  @override
  Widget build(BuildContext context) {
    final selectedClothes =
        context.select((InExperienceSelectionBloc bloc) => bloc.state.clothes);
    const items = Clothes.values;
    return PropsScrollView(
      itemBuilder: (context, index) {
        final item = items[index];
        return PropSelectionElement(
          key: clothesSelectionKey(item),
          onTap: () {
            trackEvent(
              category: 'button',
              action: 'click-clothes-props',
              label: 'select-clothes-${item.name}',
            );
            context
                .read<InExperienceSelectionBloc>()
                .add(InExperienceSelectionClothesToggled(item));
          },
          name: item.name,
          isSelected: item == selectedClothes,
          imageProvider: item.toImageProvider(),
        );
      },
      itemCount: items.length,
    );
  }
}
