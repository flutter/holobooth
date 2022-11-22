part of 'in_experience_selection_bloc.dart';

enum Prop {
  helmet,
}

class InExperienceSelectionState extends Equatable {
  const InExperienceSelectionState({
    this.drawerOption,
    this.selectedProps = const [],
  });

  final DrawerOption? drawerOption;
  final List<Prop> selectedProps;

  @override
  List<Object?> get props => [drawerOption, selectedProps];

  InExperienceSelectionState copyWith({
    DrawerOption? drawerOption,
    List<Prop>? selectedProps,
  }) {
    return InExperienceSelectionState(
      drawerOption: drawerOption ?? this.drawerOption,
      selectedProps: selectedProps ?? this.selectedProps,
    );
  }
}
