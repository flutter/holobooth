part of 'in_experience_selection_bloc.dart';

class InExperienceSelectionState extends Equatable {
  const InExperienceSelectionState({
    this.hat = Hats.none,
    this.background = Background.bg01,
    this.character = Character.dash,
    this.glasses = Glasses.none,
    this.clothes = Clothes.none,
    this.handheldlLeft = HandheldlLeft.none,
  });

  final Hats hat;
  final Background background;
  final Character character;
  final Glasses glasses;
  final Clothes clothes;
  final HandheldlLeft handheldlLeft;

  @override
  List<Object?> get props => [
        hat,
        background,
        character,
        glasses,
        clothes,
        handheldlLeft,
      ];

  InExperienceSelectionState copyWith({
    Hats? hat,
    Background? background,
    Character? character,
    Glasses? glasses,
    Clothes? clothes,
    HandheldlLeft? handheldlLeft,
  }) {
    return InExperienceSelectionState(
      hat: hat ?? this.hat,
      background: background ?? this.background,
      character: character ?? this.character,
      glasses: glasses ?? this.glasses,
      clothes: clothes ?? this.clothes,
      handheldlLeft: handheldlLeft ?? this.handheldlLeft,
    );
  }
}
