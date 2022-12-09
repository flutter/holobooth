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

class InExperienceSelectionHatSelected extends InExperienceSelectionEvent {
  const InExperienceSelectionHatSelected(this.hat);

  final Hats hat;

  @override
  List<Object> get props => [hat];
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
