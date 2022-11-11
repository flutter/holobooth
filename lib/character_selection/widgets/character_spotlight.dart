import 'dart:math';

import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class CharacterSpotlight extends StatelessWidget {
  const CharacterSpotlight({
    super.key,
    required this.bodyHeight,
    required this.viewPortFraction,
  });

  final double bodyHeight;
  final double viewPortFraction;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final size = Size(constraints.maxHeight, constraints.maxWidth);
        return SizedBox(
          width: constraints.maxWidth * viewPortFraction * 1.4,
          height: bodyHeight,
          child: CustomPaint(
            size: size,
            painter: SpotlightBeam(),
            child: CustomPaint(
              size: size,
              painter: SpotlightShadow(),
            ),
          ),
        );
      },
    );
  }
}

@visibleForTesting
class SpotlightBeam extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pathLightBody = Path()
      ..moveTo(size.width / 3, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo((size.width / 3) * 2, 0)
      ..close();

    final paintLightBody = Paint()
      ..blendMode = BlendMode.overlay
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          PhotoboothColors.white.withOpacity(0.6),
          PhotoboothColors.white.withOpacity(0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(pathLightBody, paintLightBody);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

@visibleForTesting
class SpotlightShadow extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    canvas.save();
    // Rotation of the canvas to paint the circle and we rotate to get
    // the oval effect.
    final matrix = Matrix4.identity()
      ..translate(center.dx, center.dy)
      ..rotateX(pi * 0.43);
    canvas.transform(matrix.storage);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0XFFF4E4E4).withOpacity(0.5),
          const Color(0XFFF4E4E4).withOpacity(0)
        ],
      ).createShader(
        Rect.fromCircle(center: Offset.zero, radius: size.width / 2),
      );

    canvas
      ..drawCircle(Offset.zero, size.width / 2, paint)
      ..restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
