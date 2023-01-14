import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DownloadButton', () {
    testWidgets('opens DownloadOptionDialog on tap', (tester) async {
      await tester.pumpApp(DownloadButton());
      await tester.tap(find.byType(DownloadButton));
      await tester.pumpAndSettle();
      expect(find.byType(DownloadOptionDialog), findsOneWidget);
    });

    testWidgets('closes DownloadOptionDialog tapping on DownloadAsAGifButton',
        (tester) async {
      await tester.pumpApp(DownloadButton());
      await tester.tap(find.byType(DownloadButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DownloadAsAGifButton));
      await tester.pumpAndSettle();
      expect(find.byType(DownloadOptionDialog), findsNothing);
    });

    testWidgets('closes DownloadOptionDialog tapping on DownloadAsAVideoButton',
        (tester) async {
      await tester.pumpApp(DownloadButton());
      await tester.tap(find.byType(DownloadButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DownloadAsAVideoButton));
      await tester.pumpAndSettle();
      expect(find.byType(DownloadOptionDialog), findsNothing);
    });
  });
}
