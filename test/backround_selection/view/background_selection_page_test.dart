import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/backround_selection/view/background_selection_page.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';

import '../../helpers/helpers.dart';

void main() {
  group('BackgroundSelectionPage', () {
    test('has a route', () {
      expect(BackgroundSelectionPage.route(), isA<MaterialPageRoute<void>>());
    });

    testWidgets('renders BackgroundSelectionView', (tester) async {
      await tester.pumpApp(
        Navigator(
          onGenerateRoute: (_) => BackgroundSelectionPage.route(),
        ),
      );
      expect(find.byType(BackgroundSelectionView), findsOneWidget);
    });
  });

  group('BackgroundSelectionView', () {
    testWidgets('renders a grid with all background options', (tester) async {
      await tester.pumpApp(const BackgroundSelectionView());
      expect(find.byType(Card), findsNWidgets(6));
    });

    testWidgets(
        'ActionChip button navigates to CharacterSelectionPage when pressed',
        (tester) async {
      await tester.pumpApp(const BackgroundSelectionView());
      final chipFinder = find.byType(ActionChip);
      await tester.ensureVisible(chipFinder);
      await tester.pumpAndSettle();
      await tester.tap(chipFinder);
      await tester.pumpAndSettle();
      expect(find.byType(CharacterSelectionPage), findsOneWidget);
    });
  });
}
