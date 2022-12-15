import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class PropsScrollView extends StatelessWidget {
  const PropsScrollView({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
  });

  final Widget? Function(BuildContext context, int index) itemBuilder;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final isSmall =
        MediaQuery.of(context).size.width <= PhotoboothBreakpoints.small;
    if (isSmall) {
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
