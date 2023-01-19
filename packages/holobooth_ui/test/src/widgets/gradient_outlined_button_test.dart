import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

void main() {
  group('GradientOutlinedButton', () {
    testWidgets('renders CircularProgressIndicator if loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GradientOutlinedButton(
            onPressed: () {},
            icon: const Icon(Icons.abc),
            label: 'Button',
            loading: true,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GradientOutlinedButton(
            onPressed: () {},
            icon: const Icon(Icons.abc),
            label: 'Button',
          ),
        ),
      );

      expect(find.byIcon(Icons.abc), findsOneWidget);
      expect(find.text('Button'), findsOneWidget);
      expect(find.byType(GradientOutlinedButton), findsOneWidget);
    });

    testWidgets('can be pressed', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: GradientOutlinedButton(
            onPressed: () => pressed = true,
            icon: const Icon(Icons.abc),
            label: 'Button',
          ),
        ),
      );

      await tester.tap(find.text('Button'));
      await tester.pump();

      expect(pressed, isTrue);
    });
  });
}
