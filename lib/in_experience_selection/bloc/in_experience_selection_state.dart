part of 'in_experience_selection_bloc.dart';

class InExperienceSelectionState extends Equatable {
  const InExperienceSelectionState({
    this.selectedHat = Hats.none,
    this.background = Background.space,
    this.character = Character.dash,
  });

  final Hats selectedHat;
  final Background background;
  final Character character;

  @override
  List<Object?> get props => [
        selectedHat,
        background,
        character,
      ];

  InExperienceSelectionState copyWith({
    Hats? selectedHat,
    Background? background,
    Character? character,
  }) {
    return InExperienceSelectionState(
      selectedHat: selectedHat ?? this.selectedHat,
      background: background ?? this.background,
      character: character ?? this.character,
    );
  }
}
