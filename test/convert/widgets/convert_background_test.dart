import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/convert/convert.dart';

void main() {
  group('ConvertBackground', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ConvertBackground(),
        ),
      );

      expect(find.byType(ConvertBackground), findsOneWidget);
    });
  });
}
