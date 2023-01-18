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
    });

    group('InExperienceSelectionBackgroundSelected', () {
      test('support value comparison', () {
        final eventA = InExperienceSelectionBackgroundSelected(Background.bg1);
        final eventB = InExperienceSelectionBackgroundSelected(Background.bg1);
        final eventC = InExperienceSelectionBackgroundSelected(Background.bg2);
        expect(eventA, equals(eventB));
        expect(eventA, isNot(equals(eventC)));
      });
    });
  });
}
