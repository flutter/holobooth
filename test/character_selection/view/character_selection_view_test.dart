import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CharacterSelectionView', () {
    test('can be instantiaded', () {
      expect(CharacterSelectionView(), isA<CharacterSelectionView>());
    });

    testWidgets('renders a CharacterSelectionBackground', (tester) async {
      await tester.pumpApp(const CharacterSelectionView());
      expect(find.byType(CharacterSelectionBackground), findsOneWidget);
    });

    testWidgets('renders a CharacterSelectionBody', (tester) async {
      await tester.pumpApp(const CharacterSelectionView());
      expect(find.byType(CharacterSelectionBody), findsOneWidget);
    });
  });
}
