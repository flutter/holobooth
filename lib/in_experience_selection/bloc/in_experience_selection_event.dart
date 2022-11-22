part of 'in_experience_selection_bloc.dart';

abstract class InExperienceSelectionEvent extends Equatable {
  const InExperienceSelectionEvent();
}

class InExperienceSelectionOptionSelected extends InExperienceSelectionEvent {
  const InExperienceSelectionOptionSelected({required this.drawerOption});

  final DrawerOption drawerOption;

  @override
  List<Object> get props => [drawerOption];
}

class InExperienceSelectionOptionUnselected extends InExperienceSelectionEvent {
  const InExperienceSelectionOptionUnselected();

  @override
  List<Object> get props => [];
}

class InExperienceSelectionPropSelected extends InExperienceSelectionEvent {
  const InExperienceSelectionPropSelected(this.prop);

  final Prop prop;

  @override
  List<Object> get props => [prop];
}
