import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ShareDialogBody', () {
    testWidgets(
      'renders SmallShareDialogBody on small screen',
      (WidgetTester tester) async {
        tester.setSmallDisplaySize();
        await tester.pumpApp(ShareDialogBody());
        expect(find.byType(SmallShareDialogBody), findsOneWidget);
      },
    );

    testWidgets(
      'renders LargeShareDialogBody on large screen',
      (WidgetTester tester) async {
        tester.setLargeDisplaySize();
        await tester.pumpApp(ShareDialogBody());
        expect(find.byType(LargeShareDialogBody), findsOneWidget);
      },
    );

    testWidgets(
      'can be closed clicking in ShareDialogCloseButton',
      (WidgetTester tester) async {
        await tester.pumpApp(ShareDialogBody());
        await tester.tap(find.byType(ShareDialogCloseButton));
        await tester.pumpAndSettle();
        expect(find.byType(ShareDialogBody), findsNothing);
      },
    );
  });
}
