import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';

void main() {
  group('CharacterSelectionBloc', () {
    group('constructor', () {
      test('can be instantiated', () {
        expect(CharacterSelectionBloc(), isA<CharacterSelectionBloc>());
      });

      test('initial state is Character.dash', () {
        expect(CharacterSelectionBloc().state, Character.dash);
      });
    });

    group('CharacterSelectionSelected', () {
      blocTest<CharacterSelectionBloc, Character>(
        'emits new Character when adding CharacterSelectionSelected',
        build: CharacterSelectionBloc.new,
        act: (bloc) => bloc.add(CharacterSelectionSelected(Character.sparky)),
        expect: () => <Character>[
          Character.sparky,
        ],
      );
    });
  });
}
