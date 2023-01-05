import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photo_booth/widgets/widgets.dart';

import '../../helpers/helpers.dart';

void main() {
  group('HoloBoothCharacterError', () {
    test('can be instantiated', () {
      expect(HoloBoothCharacterError(), isNotNull);
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(HoloBoothCharacterError());
      expect(find.byType(HoloBoothCharacterError), findsOneWidget);
    });
  });
}
