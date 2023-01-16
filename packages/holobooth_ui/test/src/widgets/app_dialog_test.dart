import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

void main() {
  group('showAppDialog', () {
    testWidgets('shows the child as a dialog', (tester) async {
      const childKey = Key('child');
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => showAppDialog<void>(
                context: context,
                child: const SizedBox(
                  key: childKey,
                ),
              ),
              child: const Text('open dialog'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open dialog'));
      await tester.pumpAndSettle();

      expect(find.byKey(childKey), findsOneWidget);
    });
  });
}
