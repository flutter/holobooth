import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';

class MiscellaneousSelectionTabBarView extends StatelessWidget {
  const MiscellaneousSelectionTabBarView({super.key});

  @visibleForTesting
  static Key miscellaneousSelectionKey(HandheldlLeft item) {
    return Key('miscellaneous_selection_${item.name}');
  }

  @override
  Widget build(BuildContext context) {
    final selectedHandheldlLeft = context
        .select((InExperienceSelectionBloc bloc) => bloc.state.handheldlLeft);
    const items = HandheldlLeft.values;
    return PropsGridView(
      itemBuilder: (context, index) {
        final item = items[index];
        return PropSelectionElement(
          key: miscellaneousSelectionKey(item),
          onTap: () {
            context
                .read<InExperienceSelectionBloc>()
                .add(InExperienceSelectionHandleheldLeftSelected(item));
          },
          name: item.name,
          isSelected: item == selectedHandheldlLeft,
        );
      },
      itemCount: items.length,
    );
  }
}
