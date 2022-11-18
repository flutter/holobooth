import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class CharacterSelectionBackground extends StatelessWidget {
  const CharacterSelectionBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: Gradients(
        gradient: UnmodifiableListView(
          [
            const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                PhotoboothColors.purple,
                PhotoboothColors.blue,
              ],
            ),
            LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

@visibleForTesting
class Gradients extends CustomPainter {
  Gradients({required this.gradient});

  final UnmodifiableListView<Gradient> gradient;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint();
    for (final gradient in gradient) {
      paint.shader = gradient.createShader(rect);
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant Gradients oldDelegate) => false;
}
