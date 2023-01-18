part of 'in_experience_selection_bloc.dart';

abstract class InExperienceSelectionEvent extends Equatable {
  const InExperienceSelectionEvent();
}

class InExperienceSelectionHatToggled extends InExperienceSelectionEvent
    with AnalyticsEventMixin {
  const InExperienceSelectionHatToggled(this.hat);

  @override
  AnalyticsEvent get event => AnalyticsEvent(
        category: 'button',
        action: 'click-hats-props',
        label: 'select-hats-${hat.name}',
      );

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

class InExperienceSelectionCharacterSelected extends InExperienceSelectionEvent
    with AnalyticsEventMixin {
  const InExperienceSelectionCharacterSelected(this.character);

  @override
  AnalyticsEvent get event => AnalyticsEvent(
        category: 'button',
        action: 'click-character',
        label: 'select-character-${character.name}',
      );

  final Character character;

  @override
  List<Object> get props => [character];
}

class InExperienceSelectionGlassesToggled extends InExperienceSelectionEvent
    with AnalyticsEventMixin {
  const InExperienceSelectionGlassesToggled(this.glasses);

  @override
  AnalyticsEvent get event => AnalyticsEvent(
        category: 'button',
        action: 'click-glasses-props',
        label: 'select-glasses-${glasses.name}',
      );

  final Glasses glasses;

  @override
  List<Object> get props => [glasses];
}

class InExperienceSelectionClothesToggled extends InExperienceSelectionEvent
    with AnalyticsEventMixin {
  const InExperienceSelectionClothesToggled(this.clothes);

  @override
  AnalyticsEvent get event => AnalyticsEvent(
        category: 'button',
        action: 'click-clothes-props',
        label: 'select-clothes-${clothes.name}',
      );

  final Clothes clothes;

  @override
  List<Object> get props => [clothes];
}

class InExperienceSelectionHandleheldLeftToggled
    extends InExperienceSelectionEvent with AnalyticsEventMixin {
  const InExperienceSelectionHandleheldLeftToggled(this.handheldlLeft);

  @override
  AnalyticsEvent get event => AnalyticsEvent(
        category: 'button',
        action: 'click-handheldLeft-props',
        label: 'select-handheldLeft-${handheldlLeft.name}',
      );

  final HandheldlLeft handheldlLeft;

  @override
  List<Object> get props => [handheldlLeft];
}
