import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class PropsGridView extends StatelessWidget {
  const PropsGridView({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
  });

  final Widget? Function(BuildContext context, int index) itemBuilder;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).size.width <= PhotoboothBreakpoints.small;
    if (isPortrait) {
      return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: itemBuilder,
        separatorBuilder: (context, index) => const SizedBox.square(
          dimension: 1,
        ),
        itemCount: itemCount,
      );
    }
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
