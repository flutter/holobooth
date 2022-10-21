import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';

void main() {
  group('CharacterSelected', () {
    test('can be instantiated', () {
      expect(CharacterSelected(Character.dash), isA<CharacterSelected>());
    });

    group('supports value equality', () {
      test('is false when Character differs', () {
        final stateA = CharacterSelected(Character.dash);
        final stateB = CharacterSelected(Character.sparky);
        expect(stateA == stateB, isFalse);
      });

      test('is true when Character are the same', () {
        final stateA = CharacterSelected(Character.dash);
        final stateB = CharacterSelected(Character.dash);
        expect(stateA == stateB, isTrue);
      });
    });
  });
}
