import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';

void main() {
  group('InExperienceSelectionEvent', () {
    group('InExperienceSelectionHatToggled', () {
      test('support value comparison', () {
        final eventA = InExperienceSelectionHatToggled(Hats.astronaut);
        final eventB = InExperienceSelectionHatToggled(Hats.astronaut);
        final eventC = InExperienceSelectionHatToggled(Hats.none);
        expect(eventA, equals(eventB));
        expect(eventA, isNot(equals(eventC)));
      });
    });

    group('InExperienceSelectionBackgroundSelected', () {
      test('support value comparison', () {
        final eventA = InExperienceSelectionBackgroundSelected(Background.bg01);
        final eventB = InExperienceSelectionBackgroundSelected(Background.bg01);
        final eventC = InExperienceSelectionBackgroundSelected(Background.bg02);
        expect(eventA, equals(eventB));
        expect(eventA, isNot(equals(eventC)));
      });
    });
  });
}
