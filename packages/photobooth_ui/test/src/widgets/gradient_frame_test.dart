import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('GradientFrame', () {
    testWidgets('renders child', (tester) async {
      const childKey = Key('child');
      await tester.pumpWidget(
        const Material(
          child: GradientFrame(child: SizedBox(key: childKey)),
        ),
      );
      expect(find.byKey(childKey), findsOneWidget);
    });
  });
}
