import 'package:analytics_repository/analytics_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/in_experience_selection/in_experience_selection.dart';

void main() {
  group('InExperienceSelectionEvent', () {
    group('InExperienceSelectionHatToggled', () {
      test('support value comparison', () {
        final eventA = InExperienceSelectionHatToggled(Hats.hat01);
        final eventB = InExperienceSelectionHatToggled(Hats.hat01);
        final eventC = InExperienceSelectionHatToggled(Hats.none);
        expect(eventA, equals(eventB));
        expect(eventA, isNot(equals(eventC)));
      });

      test('has an analytics event', () {
        final blocEvent = InExperienceSelectionHatToggled(Hats.hat01);
        expect(blocEvent.event, isA<AnalyticsEvent>());
      });
    });

    group('InExperienceSelectionBackgroundSelected', () {
      test('support value comparison', () {
        final eventA = InExperienceSelectionBackgroundSelected(Background.bg1);
        final eventB = InExperienceSelectionBackgroundSelected(Background.bg1);
        final eventC = InExperienceSelectionBackgroundSelected(Background.bg2);
        expect(eventA, equals(eventB));
        expect(eventA, isNot(equals(eventC)));
      });

      test('has an analytics event', () {
        final blocEvent =
            InExperienceSelectionBackgroundSelected(Background.bg1);
        expect(blocEvent.event, isA<AnalyticsEvent>());
      });
    });

    group('InExperienceSelectionCharacterSelected', () {
      test('has an analytics event', () {
        final blocEvent =
            InExperienceSelectionCharacterSelected(Character.dash);
        expect(blocEvent.event, isA<AnalyticsEvent>());
      });
    });

    group('InExperienceSelectionGlassesToggled', () {
      test('has an analytics event', () {
        final blocEvent =
            InExperienceSelectionGlassesToggled(Glasses.glasses01);
        expect(blocEvent.event, isA<AnalyticsEvent>());
      });
    });

    group('InExperienceSelectionClothesToggled', () {
      test('has an analytics event', () {
        final blocEvent = InExperienceSelectionClothesToggled(Clothes.shirt01);
        expect(blocEvent.event, isA<AnalyticsEvent>());
      });
    });

    group('InExperienceSelectionHandleheldLeftToggled', () {
      test('has an analytics event', () {
        final blocEvent = InExperienceSelectionHandleheldLeftToggled(
          HandheldlLeft.handheld01,
        );
        expect(blocEvent.event, isA<AnalyticsEvent>());
      });
    });
  });
}
