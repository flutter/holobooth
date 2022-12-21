import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/convert/convert.dart';

void main() {
  group('ConvertMessage', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ConvertMessage(),
        ),
      );

      expect(find.byType(ConvertMessage), findsOneWidget);
    });
  });
}
