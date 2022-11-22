part of 'in_experience_selection_bloc.dart';

abstract class InExperienceSelectionEvent extends Equatable {
  const InExperienceSelectionEvent();
}

class PropsSelected extends InExperienceSelectionEvent {
  const PropsSelected(this.prop);

  final Prop prop;

  @override
  List<Object> get props => [prop];
}

class InExperienceSelectionOptionSelected extends InExperienceSelectionEvent {
  const InExperienceSelectionOptionSelected({this.drawerOption});

  final DrawerOption? drawerOption;

  @override
  List<Object?> get props => [drawerOption];
}
