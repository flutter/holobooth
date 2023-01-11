import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/rive/rive.dart';

void main() {
  group('BackgroundAnimation', () {
    testWidgets('can update background', (tester) async {
      late StateSetter stateSetter;
      var background = Background.bg01;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              stateSetter = setState;
              return BackgroundAnimation(backgroundSelected: background);
            },
          ),
        ),
      );

      final state = tester.state(find.byType(BackgroundAnimation))
          as BackgroundAnimationState;
      final controller = state.backgroundController!;

      final backgroundValue = controller.background.value;

      stateSetter(() {
        background = Background.bg02;
      });

      await tester.pump(Duration(milliseconds: 150));
      await tester.pump(Duration(milliseconds: 150));

      expect(controller.background.value, isNot(equals(backgroundValue)));
      await tester.pump(kThemeAnimationDuration);
    });
  });
}
