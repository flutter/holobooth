import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class _SubjectBuilder extends StatelessWidget {
  const _SubjectBuilder({required this.builder});

  final ItemSelectorButton Function(BuildContext) builder;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(builder: builder),
      ),
    );
  }
}

void main() {
  group('Golden tests for ItemSelectorButton', () {
    goldenTest(
      'ItemSelectorButton',
      fileName: 'item_selector_button',
      builder: () {
        final selectorButtonScenario = GoldenTestScenario(
          name: 'button',
          child: _SubjectBuilder(
            builder: (_) {
              return const ItemSelectorButton(
                title: 'title',
                showTitle: true,
                child: Text('1'),
              );
            },
          ),
        );
        return GoldenTestGroup(children: [selectorButtonScenario]);
      },
    );
  });
}
