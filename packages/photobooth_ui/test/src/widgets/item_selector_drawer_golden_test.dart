import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class _SubjectBuilder extends StatelessWidget {
  const _SubjectBuilder({required this.builder});

  final ItemSelectorDrawer<Color> builder;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: builder,
      ),
    );
  }
}

void main() {
  group('Golden tests for ItemSelectorDrawer', () {
    goldenTest(
      'ItemSelectorDrawer',
      fileName: 'item_selector_drawer',
      builder: () {
        final drawer = GoldenTestScenario(
          name: 'drawer',
          child: _SubjectBuilder(
            builder: ItemSelectorDrawer(
              title: 'Drawer',
              items: const [Colors.blue, Colors.red, Colors.green],
              itemBuilder: (context, item) => ColoredBox(color: item),
              selectedItem: Colors.blue,
              onSelected: (item) => print,
            ),
          ),
        );
        return GoldenTestGroup(children: [drawer]);
      },
    );
  });
}
