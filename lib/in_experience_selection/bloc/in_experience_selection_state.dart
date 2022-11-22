part of 'in_experience_selection_bloc.dart';

class InExperienceSelectionState extends Equatable {
  const InExperienceSelectionState({this.drawerOption});

  final DrawerOption? drawerOption;

  @override
  List<Object?> get props => [drawerOption];

  InExperienceSelectionState copyWith({
    DrawerOption? drawerOption,
  }) {
    return InExperienceSelectionState(
      drawerOption: drawerOption ?? this.drawerOption,
    );
  }
}
