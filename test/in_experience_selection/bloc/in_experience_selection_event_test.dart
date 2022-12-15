import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';

void main() {
  group('InExperienceSelectionEvent', () {
    group('InExperienceSelectionHatToggled', () {
      test('support value comparison', () {
        final eventA = InExperienceSelectionHatToggled(Hats.helmet);
        final eventB = InExperienceSelectionHatToggled(Hats.helmet);
        final eventC = InExperienceSelectionHatToggled(Hats.none);
        expect(eventA, equals(eventB));
        expect(eventA, isNot(equals(eventC)));
      });
    });

    group('InExperienceSelectionBackgroundSelected', () {
      test('support value comparison', () {
        final eventA =
            InExperienceSelectionBackgroundSelected(Background.beach);
        final eventB =
            InExperienceSelectionBackgroundSelected(Background.beach);
        final eventC =
            InExperienceSelectionBackgroundSelected(Background.space);
        expect(eventA, equals(eventB));
        expect(eventA, isNot(equals(eventC)));
      });
    });
  });
}
