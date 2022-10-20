import 'package:flutter/material.dart';
import 'package:photobooth_ui/src/colors.dart';

class ItemSelectorButton extends StatelessWidget {
  const ItemSelectorButton(
      {required this.buttonBackground,
      required this.title,
      required this.onTap});

  final Widget buttonBackground;

  final String title;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: PhotoboothColors.black.withOpacity(0.75),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.all(12),
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: PhotoboothColors.white),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Stack(
          children: [
            DecoratedBox(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: PhotoboothColors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: SizedBox.square(
                    dimension: 80,
                    child: buttonBackground,
                  ),
                ),
              ),
            ),
            SizedBox.square(
              dimension: 90,
              child: Material(
                type: MaterialType.transparency,
                clipBehavior: Clip.hardEdge,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onTap,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
