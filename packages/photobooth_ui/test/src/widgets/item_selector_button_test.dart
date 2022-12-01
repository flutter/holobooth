import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('ItemSelectorButton', () {
    testWidgets(
      'renders title if title=true',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: ItemSelectorButton(
              title: 'title',
              showTitle: true,
              child: SizedBox(),
            ),
          ),
        );
        expect(find.byType(Text), findsOneWidget);
        expect(find.text('title'), findsOneWidget);
      },
    );

    testWidgets(
      'does not render title if title=false',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: ItemSelectorButton(
              title: 'title',
              showTitle: false,
              child: SizedBox(),
            ),
          ),
        );
        expect(find.byType(Text), findsNothing);
        expect(find.text('title'), findsNothing);
      },
    );

    testWidgets(
      'renders child',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: ItemSelectorButton(
              title: 'title',
              showTitle: true,
              child: SizedBox(
                key: Key('child'),
              ),
            ),
          ),
        );
        expect(find.byKey(const Key('child')), findsOneWidget);
      },
    );
  });
}
