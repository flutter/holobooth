import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// {@template gradient_text}
/// A widget that wraps [ShaderMask] around [SelectableText] to
/// create a text with gradient color.
/// {@endtemplate}
class GradientText extends StatelessWidget {
  /// {@macro gradient_text}
  const GradientText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.gradient = HoloBoothGradients.secondaryFour,
  });

  /// The text.
  final String text;

  /// Optional text style.
  final TextStyle? style;

  /// Optional text alignment.
  final TextAlign? textAlign;

  /// Gradient for the gradient text.
  final Gradient gradient;

  static const _defaultTextStyle = TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(Offset.zero & bounds.size);
      },
      child: SelectableText(
        text,
        style: style?.merge(_defaultTextStyle) ?? _defaultTextStyle,
        textAlign: textAlign,
      ),
    );
  }
}
