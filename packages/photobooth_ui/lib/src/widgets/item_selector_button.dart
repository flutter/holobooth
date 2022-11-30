import 'package:flutter/material.dart';
import 'package:photobooth_ui/src/colors.dart';

/// {@template item_selector_button}
/// The button to select a background or a character.
/// {@endtemplate}
class ItemSelectorButton extends StatelessWidget {
  /// {@macro item_selector_button}
  const ItemSelectorButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.showTitle,
    required this.child,
  });

  /// The title of the button.
  final String title;

  /// Boolean whether to show title of button.
  final bool showTitle;

  /// The function when button is tapped.
  final VoidCallback onTap;

  /// The content of the button.
  final Widget child;

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
        if (showTitle) const SizedBox(height: 24),
        child,
      ],
    );
  }
}
