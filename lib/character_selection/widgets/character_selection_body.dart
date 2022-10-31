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
          Align(
            alignment: Alignment.topCenter,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double viewPortFraction;
                if (constraints.maxWidth <= PhotoboothBreakpoints.small) {
                  viewPortFraction = 1;
                } else if (constraints.maxWidth <=
                    PhotoboothBreakpoints.medium) {
                  viewPortFraction = 0.6;
                } else {
                  viewPortFraction = 0.2;
                }
                return Container(
                  width: size.width * viewPortFraction,
                  child: CustomPaint(
                    size: MediaQuery.of(context).size,
                    painter: DrawTriangle(),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.red.withOpacity(0.2),
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
    var path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, Paint()..color = Colors.green);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
