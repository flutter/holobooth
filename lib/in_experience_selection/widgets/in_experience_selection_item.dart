import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class InExperienceSelectionItem extends StatelessWidget {
  const InExperienceSelectionItem({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: PhotoboothColors.blue,
      child: Center(
        child: Text(
          name,
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: PhotoboothColors.white),
        ),
      ),
    );
  }
}
