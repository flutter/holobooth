import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/drawer_selection/bloc/drawer_selection_bloc.dart';
import 'package:io_photobooth/drawer_selection/drawer_option/drawer_option.dart';

void main() {
  group('DrawerSelection Event', () {
    test('supports value comparisons', () {
      expect(
        DrawerSelectionOptionSelected(drawerOption: DrawerOption.backgrounds),
        DrawerSelectionOptionSelected(drawerOption: DrawerOption.backgrounds),
      );
      expect(
        DrawerSelectionOptionSelected(drawerOption: DrawerOption.backgrounds),
        isNot(
          DrawerSelectionOptionSelected(drawerOption: DrawerOption.props),
        ),
      );
    });
  });
}
