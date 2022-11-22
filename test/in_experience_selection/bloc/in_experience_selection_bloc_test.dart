import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';

void main() {
  group('InExperienceSelection', () {
    group('InExperienceSelectionOptionSelected', () {
      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits Characters when Characters is selected',
        build: InExperienceSelectionBloc.new,
        act: (bloc) => bloc.add(
          InExperienceSelectionOptionSelected(
              drawerOption: DrawerOption.characters),
        ),
        expect: () => [
          drawerSelectionState.copyWith(drawerOption: DrawerOption.characters)
        ],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits Props when Props is selected',
        build: InExperienceSelectionBloc.new,
        act: (bloc) => bloc.add(
          InExperienceSelectionOptionSelected(drawerOption: DrawerOption.props),
        ),
        expect: () =>
            [drawerSelectionState.copyWith(drawerOption: DrawerOption.props)],
      );

      blocTest<InExperienceSelectionBloc, InExperienceSelectionState>(
        'emits Backgrounds when Backgrounds is selected',
        build: InExperienceSelectionBloc.new,
        act: (bloc) => bloc.add(
          InExperienceSelectionOptionSelected(
              drawerOption: DrawerOption.backgrounds),
        ),
        expect: () => [
          drawerSelectionState.copyWith(drawerOption: DrawerOption.backgrounds)
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
