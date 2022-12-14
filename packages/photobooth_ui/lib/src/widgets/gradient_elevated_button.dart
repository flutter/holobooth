import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// {@template gradient_evelevated_button}
///
/// A wrapper around Material's that renders an [ElevatedButton]
/// with a gradient background.
///
/// {@endtemplate}
class GradientElevatedButton extends StatelessWidget {
  /// {@macro gradient_evelevated_button}
  const GradientElevatedButton({
    super.key,
    required this.child,
    required this.onPressed,
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
        gradient: const LinearGradient(
          colors: [
            HoloBoothColors.purple,
            HoloBoothColors.pink,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: HoloBoothColors.lightPurple.withOpacity(.25),
            offset: const Offset(0, 6),
            blurRadius: 6,
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
