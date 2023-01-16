import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

void main() {
  group('BlurryContainer', () {
    testWidgets('renders correctly a child', (tester) async {
      const childKey = Key('child');
      await tester.pumpWidget(
        const MaterialApp(
          home: BlurryContainer(
            child: SizedBox(key: childKey),
          ),
        ),
      );

      expect(find.byType(BlurryContainer), findsOneWidget);
      expect(find.byKey(childKey), findsOneWidget);
    });
  });
}
