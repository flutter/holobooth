import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/drawer_selection/bloc/drawer_selection_bloc.dart';
import 'package:io_photobooth/drawer_selection/drawer_option/drawer_option.dart';

void main() {
  group('DrawerSelectionState', () {
    test('supports value comparison', () {
      expect(
        DrawerSelectionState(drawerOption: DrawerOption.backgrounds),
        equals(DrawerSelectionState(drawerOption: DrawerOption.backgrounds)),
      );
    });

    test('returns same object when no propertes are passed', () {
      expect(DrawerSelectionState().copyWith(), DrawerSelectionState());
    });

    test('returns updated instance when Characters is selected', () {
      expect(
        DrawerSelectionState().copyWith(drawerOption: DrawerOption.characters),
        DrawerSelectionState(drawerOption: DrawerOption.characters),
      );
    });
  });
}
