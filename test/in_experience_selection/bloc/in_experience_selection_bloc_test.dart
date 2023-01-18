import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/in_experience_selection/in_experience_selection.dart';

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
        act: (bloc) => bloc.add(InExperienceSelectionHatToggled(Hats.hat01)),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(hat: Hats.hat01)
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state without hat when hat was previously selected.',
        build: InExperienceSelectionBloc.new,
        seed: () => InExperienceSelectionState(hat: Hats.hat01),
        act: (bloc) => bloc.add(InExperienceSelectionHatToggled(Hats.hat01)),
        expect: () =>
            const <InExperienceSelectionState>[InExperienceSelectionState()],
      );
    });

    group('InExperienceSelectionBackgroundSelected', () {
      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state with background selected.',
        build: InExperienceSelectionBloc.new,
        act: (bloc) =>
            bloc.add(InExperienceSelectionBackgroundSelected(Background.bg2)),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(background: Background.bg2)
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'does not emit new state if background already selected.',
        build: InExperienceSelectionBloc.new,
        seed: () => InExperienceSelectionState(background: Background.bg2),
        act: (bloc) =>
            bloc.add(InExperienceSelectionBackgroundSelected(Background.bg2)),
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

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state clearing props and keeping background.',
        build: InExperienceSelectionBloc.new,
        seed: () => InExperienceSelectionState(
          background: Background.bg8,
          clothes: Clothes.shirt01,
          glasses: Glasses.glasses01,
          handheldlLeft: HandheldlLeft.handheld01,
          hat: Hats.hat01,
        ),
        act: (bloc) =>
            bloc.add(InExperienceSelectionCharacterSelected(Character.sparky)),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(
            character: Character.sparky,
            background: Background.bg8,
          )
        ],
      );
    });

    group('InExperienceSelectionGlassesToggled', () {
      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state with glasses selected.',
        build: InExperienceSelectionBloc.new,
        act: (bloc) =>
            bloc.add(InExperienceSelectionGlassesToggled(Glasses.glasses01)),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(glasses: Glasses.glasses01)
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state without glasses when glasses were previously selected.',
        build: InExperienceSelectionBloc.new,
        seed: () => InExperienceSelectionState(glasses: Glasses.glasses01),
        act: (bloc) =>
            bloc.add(InExperienceSelectionGlassesToggled(Glasses.glasses01)),
        expect: () =>
            const <InExperienceSelectionState>[InExperienceSelectionState()],
      );
    });

    group('InExperienceSelectionClothesToggled', () {
      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state with clothes selected.',
        build: InExperienceSelectionBloc.new,
        act: (bloc) =>
            bloc.add(InExperienceSelectionClothesToggled(Clothes.shirt01)),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(clothes: Clothes.shirt01)
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state without clothes when clothes was previously selected.',
        build: InExperienceSelectionBloc.new,
        seed: () => InExperienceSelectionState(clothes: Clothes.shirt01),
        act: (bloc) =>
            bloc.add(InExperienceSelectionClothesToggled(Clothes.shirt01)),
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
            HandheldlLeft.handheld01,
          ),
        ),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(
            handheldlLeft: HandheldlLeft.handheld01,
          )
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state with handleheld left unselected.',
        build: InExperienceSelectionBloc.new,
        seed: () => InExperienceSelectionState(
          handheldlLeft: HandheldlLeft.handheld01,
        ),
        act: (bloc) => bloc.add(
          InExperienceSelectionHandleheldLeftToggled(
            HandheldlLeft.handheld01,
          ),
        ),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(),
        ],
      );
    });
  });
}
