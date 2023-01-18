part of 'in_experience_selection_bloc.dart';

abstract class InExperienceSelectionEvent extends Equatable {
  const InExperienceSelectionEvent();
}

class InExperienceSelectionHatToggled extends InExperienceSelectionEvent {
  const InExperienceSelectionHatToggled(this.hat);

  final Hats hat;

  @override
  List<Object> get props => [hat];
}

class InExperienceSelectionBackgroundSelected extends InExperienceSelectionEvent
    with AnalyticsEventMixin {
  const InExperienceSelectionBackgroundSelected(this.background);

  @override
  AnalyticsEvent get event => AnalyticsEvent(
        category: 'button',
        action: 'click-background',
        label: 'select-background-${background.name}',
      );

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

class InExperienceSelectionGlassesToggled extends InExperienceSelectionEvent {
  const InExperienceSelectionGlassesToggled(this.glasses);

  final Glasses glasses;

  @override
  List<Object> get props => [glasses];
}

class InExperienceSelectionClothesToggled extends InExperienceSelectionEvent {
  const InExperienceSelectionClothesToggled(this.clothes);

  final Clothes clothes;

  @override
  List<Object> get props => [clothes];
}

class InExperienceSelectionHandleheldLeftToggled
    extends InExperienceSelectionEvent {
  const InExperienceSelectionHandleheldLeftToggled(this.handheldlLeft);

  final HandheldlLeft handheldlLeft;

  @override
  List<Object> get props => [handheldlLeft];
}
