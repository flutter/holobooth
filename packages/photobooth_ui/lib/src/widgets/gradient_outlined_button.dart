import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

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
  final Widget icon;

  /// The label for the button.
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlineGradientButton(
      radius: const Radius.circular(50),
      strokeWidth: 2,
      padding: const EdgeInsets.symmetric(vertical: 16),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomCenter,
        colors: [
          HoloBoothColors.gradientSecondaryFourStart,
          HoloBoothColors.purple,
        ],
      ),
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) {
              return const LinearGradient(
                colors: [
                  Color(0xFFEFBDCF),
                  Color(0xFF9E81EF),
                ],
              ).createShader(Offset.zero & bounds.size);
            },
            child: icon,
          ),
          const SizedBox(width: 19),
          Text(
            label,
            style: const TextStyle(color: PhotoboothColors.white),
          ),
        ],
      ),
    );
  }
}
