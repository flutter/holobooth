import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../helpers/helpers.dart';

void main() {
  group('CharacterSelectionBackground', () {
    test('can be instantiated', () {
      expect(
        const GradientBackground(),
        isA<GradientBackground>(),
      );
    });

    group('renders', () {
      testWidgets('successfully', (tester) async {
        final subject = GradientBackground();
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
          const subject = GradientBackground();
          await tester.pumpWidget(subject);
          await expectLater(
            find.byWidget(subject),
            matchesGoldenFile(goldenPath('gradient_background')),
          );
        },
      );
    });
  });
}
