import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/in_experience_selection/bloc/in_experience_selection_bloc.dart';
import 'package:io_photobooth/in_experience_selection/drawer_option/drawer_option.dart';

void main() {
  group('InExperienceSelectionBloc', () {
    late InExperienceSelectionState drawerSelectionState;

    setUp(() {
      drawerSelectionState = InExperienceSelectionState();
    });

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
            drawerOption: DrawerOption.backgrounds,
          ),
        ),
        expect: () => [
          drawerSelectionState.copyWith(drawerOption: DrawerOption.backgrounds)
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
  });
}
