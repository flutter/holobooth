part of 'in_experience_selection_bloc.dart';

class InExperienceSelectionState extends Equatable {
  const InExperienceSelectionState({
    this.selectedHat = Hats.none,
    this.background = Background.space,
    this.character = Character.dash,
    this.selectedGlasses = Glasses.none,
    this.clothes = Clothes.none,
    this.handheldlLeft = HandheldlLeft.none,
  });

  final Hats selectedHat;
  final Background background;
  final Character character;
  final Glasses selectedGlasses;
  final Clothes clothes;
  final HandheldlLeft handheldlLeft;

  @override
  List<Object?> get props => [
        selectedHat,
        background,
        character,
        selectedGlasses,
        clothes,
        handheldlLeft,
      ];

  InExperienceSelectionState copyWith({
    Hats? selectedHat,
    Background? background,
    Character? character,
    Glasses? selectedGlasses,
    Clothes? clothes,
    HandheldlLeft? handheldlLeft,
  }) {
    return InExperienceSelectionState(
      selectedHat: selectedHat ?? this.selectedHat,
      background: background ?? this.background,
      character: character ?? this.character,
      selectedGlasses: selectedGlasses ?? this.selectedGlasses,
      clothes: clothes ?? this.clothes,
      handheldlLeft: handheldlLeft ?? this.handheldlLeft,
    );
  }
}
