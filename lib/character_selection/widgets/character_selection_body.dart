import 'package:flutter/material.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

const height = 800.0;

class CharacterSelectionBody extends StatelessWidget {
  const CharacterSelectionBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: height,
      child: Stack(
        children: [
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
                  child: CustomPaint(
                    size: MediaQuery.of(context).size,
                    painter: DrawTriangle(),
                    child: Opacity(
                      opacity: 0.3,
                      child: CustomPaint(
                        size: MediaQuery.of(context).size,
                        painter: DrawBase(),
                      ),
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
    );
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 700,
        width: 700,
        color: Colors.red,
        child: Stack(
          children: [
            Transform.translate(
              offset: const Offset(0, -100),
              child: CustomPaint(
                size: MediaQuery.of(context).size,
                painter: DrawTriangle(),
              ),
            ),
          ],
        ),
      ),
    );

    return Column(
      children: [
        const SizedBox(height: 80),
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
        Container(
          color: Colors.red,
          child: LayoutBuilder(
            builder: (_, constraints) {
              if (constraints.maxWidth <= PhotoboothBreakpoints.small) {
                return const CharacterSelector.small();
              } else if (constraints.maxWidth <= PhotoboothBreakpoints.medium) {
                return const CharacterSelector.medium();
              } else if (constraints.maxWidth <= PhotoboothBreakpoints.large) {
                return const CharacterSelector.large();
              } else {
                return const CharacterSelector.xLarge();
              }
            },
          ),
        ),
        const SizedBox(height: 42),
        FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(PhotoBoothPage.route());
          },
          child: const Icon(Icons.arrow_right),
        ),
      ],
    );
  }
}

class DrawTriangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);

    final pathLightBody = Path()
      ..moveTo(size.width / 3, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo((size.width / 3) * 2, 0)
      ..close();
    final paintLightBody = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xffffff).withOpacity(0.3),
          Color(0xffffff).withOpacity(0),
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
    final rectangle =
        Rect.fromCenter(center: center, width: size.width, height: 125);
    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.6,
        colors: [
          Color(0xffF4E4E4),
          Color(0xffF4E4E4).withOpacity(0),
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: size.width / 2),
      );
    canvas.drawOval(rectangle, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
