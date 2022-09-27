import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/backround_selection/view/background_selection.dart';
import '../../helpers/helpers.dart';

void main() {
  group('BackgroundSelectionPage', () {
    test('has a route', () {
      expect(BackgroundSelectionPage.route(), isA<MaterialPageRoute<void>>());
    });
    testWidgets('builds the context', (tester) async {
      await tester.pumpApp(
        Navigator(
          onGenerateRoute: (_) => BackgroundSelectionPage.route(),
        ),
      );
      expect(find.byType(BackgroundSelections), findsOneWidget);
    });
    testWidgets(
        'ActionChip button navigates to CharacterSelectionPage when pressed',
        (tester) async {
      await tester.pumpApp(const BackgroundSelectionPage());
      await tester.tap(find.byType(ActionChip));
      await tester.pump();
    });
  });
  group('Background Selections', () {
    testWidgets('renders a grid with all background options', (tester) async {
      await tester.pumpApp(const BackgroundSelections());
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(6));
    });
  });
}
