import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';

void main() {
  group('InExperienceSelectionBloc', () {
    test('initial state is InExperienceSelectionState', () {
      expect(
        InExperienceSelectionBloc().state,
        InExperienceSelectionState(),
      );
    });

    group('InExperienceSelectionHatToggled', () {
      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state with hat selected.',
        build: InExperienceSelectionBloc.new,
        act: (bloc) => bloc.add(InExperienceSelectionHatToggled(Hats.helmet)),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(hat: Hats.helmet)
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state without hat when hat was previously selected.',
        build: InExperienceSelectionBloc.new,
        seed: () => InExperienceSelectionState(hat: Hats.helmet),
        act: (bloc) => bloc.add(InExperienceSelectionHatToggled(Hats.helmet)),
        expect: () =>
            const <InExperienceSelectionState>[InExperienceSelectionState()],
      );
    });

    group('InExperienceSelectionBackgroundSelected', () {
      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state with background selected.',
        build: InExperienceSelectionBloc.new,
        act: (bloc) =>
            bloc.add(InExperienceSelectionBackgroundSelected(Background.beach)),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(background: Background.beach)
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'does not emit new state if background already selected.',
        build: InExperienceSelectionBloc.new,
        seed: () => InExperienceSelectionState(background: Background.beach),
        act: (bloc) =>
            bloc.add(InExperienceSelectionBackgroundSelected(Background.beach)),
        expect: () => const <InExperienceSelectionState>[],
      );
    });

    group('InExperienceSelectionCharacterSelected', () {
      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state with character selected.',
        build: InExperienceSelectionBloc.new,
        act: (bloc) =>
            bloc.add(InExperienceSelectionCharacterSelected(Character.sparky)),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(character: Character.sparky)
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'does not emit new state if character already selected.',
        build: InExperienceSelectionBloc.new,
        seed: InExperienceSelectionState.new,
        act: (bloc) =>
            bloc.add(InExperienceSelectionCharacterSelected(Character.dash)),
        expect: () => const <InExperienceSelectionState>[],
      );
    });

    group('InExperienceSelectionGlassesToggled', () {
      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state with glasses selected.',
        build: InExperienceSelectionBloc.new,
        act: (bloc) =>
            bloc.add(InExperienceSelectionGlassesToggled(Glasses.glasses1)),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(glasses: Glasses.glasses1)
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state without glasses when glasses were previously selected.',
        build: InExperienceSelectionBloc.new,
        seed: () => InExperienceSelectionState(glasses: Glasses.glasses1),
        act: (bloc) =>
            bloc.add(InExperienceSelectionGlassesToggled(Glasses.glasses1)),
        expect: () =>
            const <InExperienceSelectionState>[InExperienceSelectionState()],
      );
    });

    group('InExperienceSelectionClothesToggled', () {
      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state with clothes selected.',
        build: InExperienceSelectionBloc.new,
        act: (bloc) =>
            bloc.add(InExperienceSelectionClothesToggled(Clothes.clothes1)),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(clothes: Clothes.clothes1)
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state without clothes when clothes was previously selected.',
        build: InExperienceSelectionBloc.new,
        seed: () => InExperienceSelectionState(clothes: Clothes.clothes1),
        act: (bloc) =>
            bloc.add(InExperienceSelectionClothesToggled(Clothes.clothes1)),
        expect: () =>
            const <InExperienceSelectionState>[InExperienceSelectionState()],
      );
    });

    group('InExperienceSelectionHandleheldLeftToggled', () {
      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state with handleheld left selected.',
        build: InExperienceSelectionBloc.new,
        act: (bloc) => bloc.add(
          InExperienceSelectionHandleheldLeftToggled(
            HandheldlLeft.handheldLeft1,
          ),
        ),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(
            handheldlLeft: HandheldlLeft.handheldLeft1,
          )
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state with handleheld left unselected.',
        build: InExperienceSelectionBloc.new,
        seed: () => InExperienceSelectionState(
          handheldlLeft: HandheldlLeft.handheldLeft1,
        ),
        act: (bloc) => bloc.add(
          InExperienceSelectionHandleheldLeftToggled(
            HandheldlLeft.handheldLeft1,
          ),
        ),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(),
        ],
      );
    });
  });
}
