import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

void main() {
  group('GradientText', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: GradientText(
            text: 'test-text',
          ),
        ),
      );

      expect(find.text('test-text'), findsOneWidget);
    });
  });
}
