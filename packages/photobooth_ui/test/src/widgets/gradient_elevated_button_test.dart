import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('GradientElevatedButton', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GradientElevatedButton(
            child: const Text('Button'),
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('Button'), findsOneWidget);
      expect(find.byType(GradientElevatedButton), findsOneWidget);
    });

    testWidgets('can be pressed', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: GradientElevatedButton(
            child: const Text('Button'),
            onPressed: () => pressed = true,
          ),
        ),
      );

      await tester.tap(find.text('Button'));
      await tester.pump();

      expect(pressed, isTrue);
    });
  });
}
