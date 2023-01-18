import 'package:flutter/material.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

/// {@template gradient_outlined_button}
/// A widget that uses a [Stack] to construct an [OutlinedButton.icon]
/// with a gradient border.
/// {@endtemplate}
class GradientOutlinedButton extends StatelessWidget {
  /// {@macro gradient_outlined_button}
  const GradientOutlinedButton({
    super.key,
    this.onPressed,
    required this.icon,
    required this.label,
  });

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// The icon for the button.
  final Widget? icon;

  /// The label for the button.
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            ShaderMask(
              shaderCallback: (bounds) {
                return HoloBoothGradients.secondaryFour
                    .createShader(Offset.zero & bounds.size);
              },
              child: icon,
            ),
            const SizedBox(width: 19),
          ],
          Text(label),
        ],
      ),
    );
  }
}
