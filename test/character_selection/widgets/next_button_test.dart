import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';

import '../../helpers/helpers.dart';

void main() {
  group('NextButton', () {
    testWidgets('navigates to PhotoBoothPage on click', (tester) async {
      await tester.pumpApp(NextButton());
      await tester.tap(find.byType(NextButton));
      await tester.pumpAndSettle();
      expect(find.byType(PhotoBoothPage), findsOneWidget);
    });
  });
}
