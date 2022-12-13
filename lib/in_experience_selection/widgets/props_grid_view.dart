import 'package:flutter/material.dart';

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
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
