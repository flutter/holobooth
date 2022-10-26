import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('CharacterSelectionBackground', () {
    test('can be instantiated', () {
      expect(
        CharacterSelectionBackground(),
        isA<CharacterSelectionBackground>(),
      );
    });

    group('renders', () {
      testWidgets('successfully', (tester) async {
        final subject = CharacterSelectionBackground();
        await tester.pumpWidget(subject);
        expect(find.byWidget(subject), findsOneWidget);
      });
    });

    group('goldens', () {
      String goldenPath(String name) => 'goldens/$name.png';

      testWidgets(
        'paints background',
        tags: TestTag.golden,
        (tester) async {
          final subject = CharacterSelectionBackground();
          await tester.pumpWidget(subject);
          await expectLater(
            find.byWidget(subject),
            matchesGoldenFile(goldenPath('character_selection_background')),
          );
        },
      );
    });
  });
}
