import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/multiple_capture_viewer/multiple_capture_viewer.dart';

void main() {
  group('ShareDialog', () {
    test('can be instantiated', () {
      expect(ShareDialog(), isA<ShareDialog>());
    });

    group('renders', () {
      testWidgets('successfully', (tester) async {
        final subject = ShareDialog();
        await tester.pumpSubject(subject);
        expect(find.byWidget(subject), findsOneWidget);
      });
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(ShareDialog subject) {
    return pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: subject,
      ),
    );
  }
}
