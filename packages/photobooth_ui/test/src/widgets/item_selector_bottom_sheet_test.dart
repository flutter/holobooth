import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('ItemSelectorBottomSheet', () {
    const title = 'title';
    const items = ['1', '2', '3', '4'];
    Widget itemBuilder(BuildContext context, String item) => Text(item);
    late String selectedItem;

    setUp(() {
      selectedItem = '1';
    });

    Widget buildSubject() => MaterialApp(
          home: Scaffold(
            body: ItemSelectorBottomSheet(
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
        await tester.scrollUntilVisible(find.text(item), 20);
        expect(find.text(item), findsOneWidget);
      }
    });

    testWidgets('calls onSelected when item is tapped', (tester) async {
      await tester.pumpWidget(buildSubject());
      for (final item in items) {
        await tester.ensureVisible(find.text(item));
        await tester.dragUntilVisible(
          find.text(item),
          find.byType(ClipRRect),
          const Offset(-200, 0),
        );
        await tester.tapAt(tester.getTopLeft(find.text(item)));
        expect(selectedItem, equals(item));
      }
    });

    testWidgets('show renders bottomSheet', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => ItemSelectorBottomSheet.show(
                  context,
                  title: title,
                  items: items,
                  itemBuilder: itemBuilder,
                  selectedItem: selectedItem,
                  onSelected: (val) {},
                ),
                child: const Text('show bottom sheet'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('show bottom sheet'));
      await tester.pumpAndSettle();
      expect(find.byType(ItemSelectorBottomSheet<String>), findsOneWidget);
    });
  });
}
