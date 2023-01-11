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
        act: (bloc) =>
            bloc.add(InExperienceSelectionHatToggled(Hats.astronaut)),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(hat: Hats.astronaut)
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state without hat when hat was previously selected.',
        build: InExperienceSelectionBloc.new,
        seed: () => InExperienceSelectionState(hat: Hats.astronaut),
        act: (bloc) =>
            bloc.add(InExperienceSelectionHatToggled(Hats.astronaut)),
        expect: () =>
            const <InExperienceSelectionState>[InExperienceSelectionState()],
      );
    });

    group('InExperienceSelectionBackgroundSelected', () {
      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state with background selected.',
        build: InExperienceSelectionBloc.new,
        act: (bloc) =>
            bloc.add(InExperienceSelectionBackgroundSelected(Background.bg02)),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(background: Background.bg02)
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'does not emit new state if background already selected.',
        build: InExperienceSelectionBloc.new,
        seed: () => InExperienceSelectionState(background: Background.bg02),
        act: (bloc) =>
            bloc.add(InExperienceSelectionBackgroundSelected(Background.bg02)),
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
            bloc.add(InExperienceSelectionGlassesToggled(Glasses.sunGlasses)),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(glasses: Glasses.sunGlasses)
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state without glasses when glasses were previously selected.',
        build: InExperienceSelectionBloc.new,
        seed: () => InExperienceSelectionState(glasses: Glasses.sunGlasses),
        act: (bloc) =>
            bloc.add(InExperienceSelectionGlassesToggled(Glasses.sunGlasses)),
        expect: () =>
            const <InExperienceSelectionState>[InExperienceSelectionState()],
      );
    });

    group('InExperienceSelectionClothesToggled', () {
      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state with clothes selected.',
        build: InExperienceSelectionBloc.new,
        act: (bloc) =>
            bloc.add(InExperienceSelectionClothesToggled(Clothes.swimmingSuit)),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(clothes: Clothes.swimmingSuit)
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state without clothes when clothes was previously selected.',
        build: InExperienceSelectionBloc.new,
        seed: () => InExperienceSelectionState(clothes: Clothes.swimmingSuit),
        act: (bloc) =>
            bloc.add(InExperienceSelectionClothesToggled(Clothes.swimmingSuit)),
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
            HandheldlLeft.apple,
          ),
        ),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(
            handheldlLeft: HandheldlLeft.apple,
          )
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state with handleheld left unselected.',
        build: InExperienceSelectionBloc.new,
        seed: () => InExperienceSelectionState(
          handheldlLeft: HandheldlLeft.apple,
        ),
        act: (bloc) => bloc.add(
          InExperienceSelectionHandleheldLeftToggled(
            HandheldlLeft.apple,
          ),
        ),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(),
        ],
      );
    });
  });
}
