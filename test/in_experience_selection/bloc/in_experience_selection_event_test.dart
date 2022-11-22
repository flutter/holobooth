import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/in_experience_selection/bloc/in_experience_selection_bloc.dart';
import 'package:io_photobooth/in_experience_selection/drawer_option/drawer_option.dart';

void main() {
  group('DrawerSelection Event', () {
    test('supports value comparisons', () {
      expect(
        InExperienceSelectionOptionSelected(
          drawerOption: DrawerOption.backgrounds,
        ),
        InExperienceSelectionOptionSelected(
          drawerOption: DrawerOption.backgrounds,
        ),
      );
      expect(
        InExperienceSelectionOptionSelected(
          drawerOption: DrawerOption.backgrounds,
        ),
        isNot(
          InExperienceSelectionOptionSelected(drawerOption: DrawerOption.props),
        ),
      );
    });
  });
}
