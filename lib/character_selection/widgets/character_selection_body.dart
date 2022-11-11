import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:io_photobooth/character_selection/widgets/character_selection_header.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class CharacterSelectionBody extends StatelessWidget {
  const CharacterSelectionBody({super.key});

  // Minimum height calculated to avoid overlap in the stack
  static const _minBodyHeight = 600.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double bodyHeight;
    double viewportFraction;
    if (size.width <= PhotoboothBreakpoints.small) {
      bodyHeight = size.height * 0.6;
      viewportFraction = 0.55;
    } else if (size.width <= PhotoboothBreakpoints.medium) {
      bodyHeight = size.height * 0.6;
      viewportFraction = 0.35;
    } else {
      bodyHeight = size.height * 0.75;
      viewportFraction = 0.2;
    }
    bodyHeight = math.max(_minBodyHeight, bodyHeight);
    return Column(
      children: [
        SizedBox(
          height: bodyHeight,
          child: Stack(
            children: [
              const Align(
                alignment: Alignment.topCenter,
                child: CharacterSelectionHeader(),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: CharacterSpotlight(
                  bodyHeight: bodyHeight,
                  viewPortFraction: viewportFraction,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CharacterSelector(viewportFraction: viewportFraction),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
