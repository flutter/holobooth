import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import '../../helpers/helpers.dart';

void main() {
  group('CharacterSelectionPage', () {
    test('has a route', () {
      expect(CharacterSelectionPage.route(), isA<MaterialPageRoute<void>>());
    });
    testWidgets('builds the context', (tester) async {
      await tester.pumpApp(
        Navigator(
          onGenerateRoute: (_) => CharacterSelectionPage.route(),
        ),
      );
      expect(find.byType(CharacterSelections), findsOneWidget);
    });
    testWidgets('ActionChip button navigates to Camera Page when pressed',
        (tester) async {
      await tester.pumpApp(const CharacterSelectionPage());
      await tester.tap(find.byType(ActionChip));
      await tester.pump();
    });
  });
  group('Character Selections', () {
    testWidgets('renders a grid with all character options', (tester) async {
      await tester.pumpApp(const CharacterSelections());
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(6));
    });
  });
}
