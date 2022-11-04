import 'dart:math';

import 'package:flutter/material.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class CharacterSelectionBody extends StatelessWidget {
  const CharacterSelectionBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final size = MediaQuery.of(context).size;
    double bodyHeight;
    if (size.width <= PhotoboothBreakpoints.small) {
      bodyHeight = size.height * 0.6;
    } else if (size.width <= PhotoboothBreakpoints.medium) {
      bodyHeight = size.height * 0.6;
    } else {
      bodyHeight = size.height * 0.75;
    }

    return Column(
      children: [
        SizedBox(
          height: bodyHeight,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 24),
                      SelectableText(
                        l10n.chooseYourCharacterTitleText,
                        style: theme.textTheme.headline1
                            ?.copyWith(color: PhotoboothColors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      SelectableText(
                        l10n.youCanChangeThemLaterSubheading,
                        style: theme.textTheme.headline3
                            ?.copyWith(color: PhotoboothColors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Light shadow
              Align(
                alignment: Alignment.topCenter,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    double viewPortFraction;
                    if (constraints.maxWidth <= PhotoboothBreakpoints.small) {
                      viewPortFraction = 0.55;
                    } else if (constraints.maxWidth <=
                        PhotoboothBreakpoints.medium) {
                      viewPortFraction = 0.3;
                    } else {
                      viewPortFraction = 0.2;
                    }
                    return SizedBox(
                      width: size.width * viewPortFraction * 1.4,
                      height: bodyHeight,
                      child: CustomPaint(
                        size: MediaQuery.of(context).size,
                        painter: DrawTriangle(),
                        child: CustomPaint(
                          size: MediaQuery.of(context).size,
                          painter: DrawBase(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Character selection
              Align(
                alignment: Alignment.bottomCenter,
                child: LayoutBuilder(
                  builder: (_, constraints) {
                    if (constraints.maxWidth <= PhotoboothBreakpoints.small) {
                      return const CharacterSelector.small();
                    } else if (constraints.maxWidth <=
                        PhotoboothBreakpoints.medium) {
                      return const CharacterSelector.medium();
                    } else if (constraints.maxWidth <=
                        PhotoboothBreakpoints.large) {
                      return const CharacterSelector.large();
                    } else {
                      return const CharacterSelector.xLarge();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 120,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(PhotoBoothPage.route());
            },
            child: const Icon(Icons.arrow_forward),
          ),
        ),
      ],
    );
  }
}

class DrawTriangle extends CustomPainter {
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
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class DrawBase extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    canvas.save();
    // Rotation of the canvas to paint the circle and we rotate to get
    //the oval effect
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
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
