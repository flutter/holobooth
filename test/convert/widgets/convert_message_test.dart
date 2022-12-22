import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/convert/convert.dart';
import 'package:io_photobooth/l10n/l10n.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ConvertMessage', () {
    testWidgets('renders correctly with texts', (tester) async {
      await tester.pumpApp(
        ConvertMessage(),
      );

      final l10n = tester.element(find.byType(ConvertMessage)).l10n;

      expect(find.text(l10n.convertMessage), findsOneWidget);
      expect(find.text(l10n.convertInfo), findsOneWidget);
    });
  });
}
