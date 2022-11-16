import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ShareButton', () {
    testWidgets('onPressed is onvoked when pressed', (tester) async {
      await tester.pumpApp(ShareButton());
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
    });
  });
}
