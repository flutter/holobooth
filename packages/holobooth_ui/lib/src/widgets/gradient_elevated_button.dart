import 'package:flutter/material.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

/// {@template gradient_evelevated_button}
///
/// A wrapper around Material's that renders an [ElevatedButton]
/// with a gradient background.
///
/// {@endtemplate}
class GradientElevatedButton extends StatelessWidget {
  /// {@macro gradient_evelevated_button}
  const GradientElevatedButton({
    required this.child,
    required this.onPressed,
    super.key,
  });

  /// Button's child.
  final Widget child;

  /// Called when the button is pressed.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        gradient: HoloBoothGradients.button,
        boxShadow: [
          BoxShadow(
            color: HoloBoothColors.lightPurple.withOpacity(.24),
            offset: const Offset(1, 6),
            blurRadius: 16,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
