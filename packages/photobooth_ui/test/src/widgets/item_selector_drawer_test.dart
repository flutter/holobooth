import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('ItemSelectorDrawer', () {
    const title = 'title';
    const items = ['1', '2', '3', '4'];
    Widget itemBuilder(BuildContext context, String item) => Text(item);
    late String selectedItem;

    setUp(() {
      selectedItem = '1';
    });

    Widget buildSubject() => MaterialApp(
          home: Scaffold(
            body: ItemSelectorDrawer(
              title: title,
              items: items,
              itemBuilder: itemBuilder,
              selectedItem: selectedItem,
              onSelected: (newSelectedItem) => selectedItem = newSelectedItem,
            ),
          ),
        );

    testWidgets('renders the title', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(find.text(title), findsOneWidget);
    });

    testWidgets('renders the list of items', (tester) async {
      await tester.pumpWidget(buildSubject());
      for (final item in items) {
        await tester.scrollUntilVisible(find.text(item), 50);
        expect(find.text(item), findsOneWidget);
      }
    });

    testWidgets('calls onSelected when item is tapped', (tester) async {
      await tester.pumpWidget(buildSubject());
      for (final item in items) {
        await tester.scrollUntilVisible(find.text(item), 200);
        await tester.tapAt(tester.getTopLeft(find.text(item)));
        expect(selectedItem, equals(item));
      }
    });
  });
}
