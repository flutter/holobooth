import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/convert/convert.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ConvertMessage', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        ConvertMessage(),
      );

      expect(find.byType(ConvertMessage), findsOneWidget);
    });
  });
}
