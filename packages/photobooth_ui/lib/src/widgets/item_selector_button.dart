import 'package:flutter/material.dart';
import 'package:photobooth_ui/src/colors.dart';

/// {@template item_selector_button}
/// The button to select a background or a character.
/// {@endtemplate}
class ItemSelectorButton extends StatelessWidget {
  /// {@macro item_selector_button}
  const ItemSelectorButton({
    super.key,
    required this.buttonBackground,
    required this.title,
    required this.onTap,
    required this.showTitle,
  });

  /// The content of the button.
  final Widget buttonBackground;

  /// The title of the button.
  final String title;

  /// Boolean whether to show title of button.
  final bool showTitle;

  /// The function when button is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showTitle)
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
        if (showTitle)
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
