import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/drawer_selection/bloc/drawer_selection_bloc.dart';
import 'package:io_photobooth/drawer_selection/drawer_option/drawer_option.dart';

void main() {
  group('DrawerSelection Bloc', () {
    late DrawerSelectionState drawerSelectionState;

    setUp(() {
      drawerSelectionState = DrawerSelectionState();
    });

    test('initial state is DrawerSelectionState', () {
      expect(DrawerSelectionBloc().state, DrawerSelectionState());
    });

    blocTest<DrawerSelectionBloc, DrawerSelectionState>(
      'emits Characters when Characters is selected',
      build: DrawerSelectionBloc.new,
      act: (bloc) => bloc.add(
        DrawerSelectionOptionSelected(drawerOption: DrawerOption.characters),
      ),
      expect: () => [
        drawerSelectionState.copyWith(drawerOption: DrawerOption.characters)
      ],
    );

    blocTest<DrawerSelectionBloc, DrawerSelectionState>(
      'emits Props when Props is selected',
      build: DrawerSelectionBloc.new,
      act: (bloc) => bloc.add(
        DrawerSelectionOptionSelected(drawerOption: DrawerOption.props),
      ),
      expect: () =>
          [drawerSelectionState.copyWith(drawerOption: DrawerOption.props)],
    );

    blocTest<DrawerSelectionBloc, DrawerSelectionState>(
      'emits Backgrounds when Backgrounds is selected',
      build: DrawerSelectionBloc.new,
      act: (bloc) => bloc.add(
        DrawerSelectionOptionSelected(drawerOption: DrawerOption.backgrounds),
      ),
      expect: () => [
        drawerSelectionState.copyWith(drawerOption: DrawerOption.backgrounds)
      ],
    );
  });
}
