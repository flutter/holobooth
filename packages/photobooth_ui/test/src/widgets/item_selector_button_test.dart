import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('ItemSelectorButton', () {
    const buttonBackground = SizedBox();
    const title = 'title';
    late bool wasPressed;

    Widget buildSubject() => MaterialApp(
          home: Scaffold(
            body: ItemSelectorButton(
              buttonBackground: buttonBackground,
              title: title,
              onTap: () {
                wasPressed = true;
              },
            ),
          ),
        );

    setUp(() {
      wasPressed = false;
    });

    testWidgets('renders the title', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(find.text(title), findsOneWidget);
    });

    testWidgets('renders button background', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(find.byWidget(buttonBackground), findsOneWidget);
    });

    testWidgets('calls onTap when icon is tapped', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.tap(find.byWidget(buttonBackground));
      expect(wasPressed, isTrue);
    });
  });
}
