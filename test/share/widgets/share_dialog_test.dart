import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ShareDialog', () {
    test('can be instantiated', () {
      expect(
        ShareDialog(),
        isA<ShareDialog>(),
      );
    });

    testWidgets('tapping on close will dismiss the popup', (tester) async {
      await tester.pumpApp(Material(child: ShareDialog()));
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();
      expect(find.byType(ShareDialog), findsNothing);
    });

    testWidgets('renders successfully', (tester) async {
      final subject = ShareDialog();
      await tester.pumpSubject(subject);
      expect(find.byWidget(subject), findsOneWidget);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(ShareDialog subject) {
    return pumpApp(
      Material(
        child: subject,
      ),
    );
  }
}
