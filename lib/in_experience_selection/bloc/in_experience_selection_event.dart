part of 'in_experience_selection_bloc.dart';

abstract class InExperienceSelectionEvent extends Equatable {
  const InExperienceSelectionEvent();
}

class InExperienceSelectionOptionSelected extends InExperienceSelectionEvent {
  const InExperienceSelectionOptionSelected({this.drawerOption});

  final DrawerOption? drawerOption;

  @override
  List<Object?> get props => [drawerOption];
}

class InExperienceSelectionPropSelected extends InExperienceSelectionEvent {
  const InExperienceSelectionPropSelected(this.prop);

  final Prop prop;

  @override
  List<Object> get props => [prop];
}

class InExperienceSelectionBackgroundSelected
    extends InExperienceSelectionEvent {
  const InExperienceSelectionBackgroundSelected(this.background);

  final Background background;

  @override
  List<Object> get props => [background];
}

class InExperienceSelectionCharacterSelected
    extends InExperienceSelectionEvent {
  const InExperienceSelectionCharacterSelected(this.character);

  final Character character;

  @override
  List<Object> get props => [character];
}
