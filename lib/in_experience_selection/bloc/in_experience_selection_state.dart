part of 'in_experience_selection_bloc.dart';

enum Prop {
  helmet,
}

enum Background {
  space,
}

class InExperienceSelectionState extends Equatable {
  const InExperienceSelectionState({
    this.selectedProps = const [],
    this.drawerOption = DrawerOption.backgrounds,
    this.background = Background.space,
  });

  final DrawerOption? drawerOption;
  final List<Prop> selectedProps;
  final Background background;

  @override
  List<Object> get props => [selectedProps];

  InExperienceSelectionState copyWith({
    List<Prop>? selectedProps,
  }) {
    return InExperienceSelectionState(
      selectedProps: selectedProps ?? this.selectedProps,
    );
  }
}
