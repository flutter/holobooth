import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';

void main() {
  group('ShareBottomSheet', () {
    test('can be instantiated', () {
      expect(ShareBottomSheet(), isA<ShareBottomSheet>());
    });

    group('renders', () {
      testWidgets('successfully', (tester) async {
        final subject = ShareBottomSheet();
        await tester.pumpSubject(subject);
        expect(find.byWidget(subject), findsOneWidget);
      });
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(ShareBottomSheet subject) {
    return pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: subject,
      ),
    );
  }
}
