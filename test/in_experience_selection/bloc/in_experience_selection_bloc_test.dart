import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';

void main() {
  group('InExperienceSelectionBloc', () {
    test('initial state is InExperienceSelectionState', () {
      expect(InExperienceSelectionBloc().state, InExperienceSelectionState());
    });

    group('InExperienceSelectionOptionSelected', () {
      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits Characters when Characters is selected',
        build: InExperienceSelectionBloc.new,
        act: (bloc) => bloc.add(
          InExperienceSelectionOptionSelected(
            drawerOption: DrawerOption.characters,
          ),
        ),
        expect: () => [
          InExperienceSelectionState(drawerOption: DrawerOption.characters),
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits Props when Props is selected',
        build: InExperienceSelectionBloc.new,
        act: (bloc) => bloc.add(
          InExperienceSelectionOptionSelected(drawerOption: DrawerOption.props),
        ),
        expect: () => [
          InExperienceSelectionState(drawerOption: DrawerOption.props),
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits Backgrounds when Backgrounds is selected',
        build: InExperienceSelectionBloc.new,
        act: (bloc) => bloc.add(
          InExperienceSelectionOptionSelected(
            drawerOption: DrawerOption.backgrounds,
          ),
        ),
        expect: () => [
          InExperienceSelectionState(drawerOption: DrawerOption.backgrounds)
        ],
      );
    });

    group('InExperienceSelectionOptionUnselected', () {
      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits initial state if previous option selected',
        build: InExperienceSelectionBloc.new,
        seed: () =>
            InExperienceSelectionState(drawerOption: DrawerOption.backgrounds),
        act: (bloc) => bloc.add(
          InExperienceSelectionOptionUnselected(),
        ),
        expect: () => [
          InExperienceSelectionState(),
        ],
      );
    });

    group('InExperienceSelectionPropSelected', () {
      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state with prop selected.',
        build: InExperienceSelectionBloc.new,
        act: (bloc) => bloc.add(InExperienceSelectionPropSelected(Prop.helmet)),
        expect: () => const <InExperienceSelectionState>[
          InExperienceSelectionState(selectedProps: [Prop.helmet])
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits state with prop unselected.',
        build: InExperienceSelectionBloc.new,
        seed: () =>
            InExperienceSelectionState(selectedProps: const [Prop.helmet]),
        act: (bloc) => bloc.add(InExperienceSelectionPropSelected(Prop.helmet)),
        expect: () =>
            const <InExperienceSelectionState>[InExperienceSelectionState()],
      );
    });
  });
}
