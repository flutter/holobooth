import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

void main() {
  group('HoloBoothAlertDialog', () {
    testWidgets('renders child', (tester) async {
      const childKey = Key('child');
      await tester.pumpWidget(
        const MaterialApp(
          home: HoloBoothAlertDialog(child: SizedBox(key: childKey)),
        ),
      );
      expect(find.byKey(childKey), findsOneWidget);
    });
  });
}
