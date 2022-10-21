import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:io_photobooth/multiple_capture/multiple_capture.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CharacterSelectionPage', () {
    test('has a route', () {
      expect(CharacterSelectionPage.route(), isA<MaterialPageRoute<void>>());
    });

    testWidgets('renders CharacterSelecionView', (tester) async {
      await tester.pumpApp(
        Navigator(
          onGenerateRoute: (_) => CharacterSelectionPage.route(),
        ),
      );
      expect(find.byType(CharacterSelections), findsOneWidget);
    });
  });

  group('CharacterSelectionView', () {
    testWidgets('renders a grid with all character options', (tester) async {
      await tester.pumpApp(const CharacterSelectionView());
      expect(find.byType(Card), findsNWidgets(6));
    });

    testWidgets(
        'ActionChip button navigates to MultipleCapturePage when pressed',
        (tester) async {
      await tester.pumpApp(const CharacterSelectionView());
      final chipFinder = find.byType(ActionChip);
      await tester.ensureVisible(chipFinder);
      await tester.pumpAndSettle();
      await tester.tap(chipFinder);
      await tester.pumpAndSettle();
      expect(find.byType(MultipleCapturePage), findsOneWidget);
    });
  });
}
