import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';

void main() {
  group('CharacterSelectionSelected', () {
    test('can be instantiated', () {
      expect(
        CharacterSelectionSelected(Character.dash),
        isA<CharacterSelectionSelected>(),
      );
    });

    group('supports value equality', () {
      test('is false when Character differs', () {
        final stateA = CharacterSelectionSelected(Character.dash);
        final stateB = CharacterSelectionSelected(Character.sparky);
        expect(stateA == stateB, isFalse);
      });

      test('is true when Character are the same', () {
        final stateA = CharacterSelectionSelected(Character.dash);
        final stateB = CharacterSelectionSelected(Character.dash);
        expect(stateA == stateB, isTrue);
      });
    });
  });
}
