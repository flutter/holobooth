part of 'in_experience_selection_bloc.dart';

class InExperienceSelectionState extends Equatable {
  const InExperienceSelectionState({
    this.drawerOption,
    this.selectedHat = Hats.none,
    this.background = Background.space,
    this.character = Character.dash,
  });

  final DrawerOption? drawerOption;
  final Hats selectedHat;
  final Background background;
  final Character character;

  @override
  List<Object?> get props => [
        drawerOption,
        selectedHat,
        background,
        character,
      ];

  InExperienceSelectionState copyWith({
    DrawerOption? drawerOption,
    Hats? selectedHat,
    Background? background,
    Character? character,
  }) {
    return InExperienceSelectionState(
      drawerOption: drawerOption ?? this.drawerOption,
      selectedHat: selectedHat ?? this.selectedHat,
      background: background ?? this.background,
      character: character ?? this.character,
    );
  }
}
