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
