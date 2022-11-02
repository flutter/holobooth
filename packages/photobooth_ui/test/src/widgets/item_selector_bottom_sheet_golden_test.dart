import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class _SubjectBuilder extends StatelessWidget {
  const _SubjectBuilder({required this.builder});

  final ItemSelectorBottomSheet<Color> builder;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          height: 600,
          child: builder,
        ),
      ),
    );
  }
}

void main() {
  group('Golden tests for ItemSelectionBottomSheet', () {
    goldenTest(
      'ItemSelectorBottomSheet',
      fileName: 'item_selector_bottom_sheet',
      builder: () {
        final bottomSheet = GoldenTestScenario(
          name: 'bottomSheet',
          child: _SubjectBuilder(
            builder: ItemSelectorBottomSheet(
              title: 'BottomSheet',
              items: const [Colors.blue, Colors.red, Colors.green],
              itemBuilder: (context, item) => ColoredBox(color: item),
              selectedItem: Colors.blue,
              onSelected: (item) => print,
            ),
          ),
        );
        return GoldenTestGroup(children: [bottomSheet]);
      },
    );
  });
}
