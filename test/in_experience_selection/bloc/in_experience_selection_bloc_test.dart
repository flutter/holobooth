import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';

void main() {
  group('InExperienceSelectionBloc', () {
    test('initial state is InExperienceSelectionState', () {
      expect(
        InExperienceSelectionBloc(characterPreSelected: Character.dash).state,
        InExperienceSelectionState(),
      );
    });

    group('InExperienceSelectionHatSelected', () {
      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state with hat selected.',
        build: () =>
            InExperienceSelectionBloc(characterPreSelected: Character.dash),
        act: (bloc) => bloc.add(InExperienceSelectionHatSelected(Hats.helmet)),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(selectedHat: Hats.helmet)
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state with hat unselected.',
        build: () =>
            InExperienceSelectionBloc(characterPreSelected: Character.dash),
        seed: () => InExperienceSelectionState(selectedHat: Hats.helmet),
        act: (bloc) => bloc.add(InExperienceSelectionHatSelected(Hats.helmet)),
        expect: () =>
            const <InExperienceSelectionState>[InExperienceSelectionState()],
      );
    });

    group('InExperienceSelectionBackgroundSelected', () {
      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state with background selected.',
        build: () =>
            InExperienceSelectionBloc(characterPreSelected: Character.dash),
        act: (bloc) =>
            bloc.add(InExperienceSelectionBackgroundSelected(Background.beach)),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(background: Background.beach)
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'does not emit new state if background already selected.',
        build: () =>
            InExperienceSelectionBloc(characterPreSelected: Character.dash),
        seed: () => InExperienceSelectionState(background: Background.beach),
        act: (bloc) =>
            bloc.add(InExperienceSelectionBackgroundSelected(Background.beach)),
        expect: () => const <InExperienceSelectionState>[],
      );
    });

    group('InExperienceSelectionCharacterSelected', () {
      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state with character selected.',
        build: () =>
            InExperienceSelectionBloc(characterPreSelected: Character.dash),
        act: (bloc) =>
            bloc.add(InExperienceSelectionCharacterSelected(Character.sparky)),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(character: Character.sparky)
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'does not emit new state if character already selected.',
        build: () =>
            InExperienceSelectionBloc(characterPreSelected: Character.dash),
        seed: InExperienceSelectionState.new,
        act: (bloc) =>
            bloc.add(InExperienceSelectionCharacterSelected(Character.dash)),
        expect: () => const <InExperienceSelectionState>[],
      );
    });

    group('InExperienceSelectionGlassesSelected', () {
      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state with glasses selected.',
        build: () =>
            InExperienceSelectionBloc(characterPreSelected: Character.dash),
        act: (bloc) =>
            bloc.add(InExperienceSelectionGlassesSelected(Glasses.glasses1)),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(selectedGlasses: Glasses.glasses1)
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state with glasses unselected.',
        build: () =>
            InExperienceSelectionBloc(characterPreSelected: Character.dash),
        seed: () =>
            InExperienceSelectionState(selectedGlasses: Glasses.glasses1),
        act: (bloc) =>
            bloc.add(InExperienceSelectionGlassesSelected(Glasses.glasses1)),
        expect: () =>
            const <InExperienceSelectionState>[InExperienceSelectionState()],
      );
    });
  });
}
