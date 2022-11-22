import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/in_experience_selection/bloc/in_experience_selection_bloc.dart';
import 'package:io_photobooth/in_experience_selection/drawer_option/drawer_option.dart';

void main() {
  group('InExperienceSelectionState', () {
    test('supports value comparison', () {
      expect(
        InExperienceSelectionState(drawerOption: DrawerOption.backgrounds),
        equals(
          InExperienceSelectionState(drawerOption: DrawerOption.backgrounds),
        ),
      );
    });

    test('returns same object when no propertes are passed', () {
      expect(
        InExperienceSelectionState().copyWith(),
        InExperienceSelectionState(),
      );
    });

    test('returns updated instance when Characters is selected', () {
      expect(
        InExperienceSelectionState()
            .copyWith(drawerOption: DrawerOption.characters),
        InExperienceSelectionState(drawerOption: DrawerOption.characters),
      );
    });
  });
}
