import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/rive/rive.dart';

void main() {
  group('BackgroundAnimation', () {
    testWidgets('udpates x and y when position changes on the animation',
        (tester) async {
      late StateSetter stateSetter;
      var vector3 = Vector3.zero;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              stateSetter = setState;
              return BackgroundAnimation.fromVector3(
                vector3,
                backgroundSelected: Background.beach,
              );
            },
          ),
        ),
      );

      final state = tester.state(find.byType(BackgroundAnimation))
          as BackgroundAnimationState;
      final controller = state.backgroundController!;

      final x = controller.x.value;
      final y = controller.y.value;

      stateSetter(() => vector3 = Vector3(1, 1, 1));

      await tester.pump(Duration(milliseconds: 150));
      await tester.pump(Duration(milliseconds: 150));

      expect(controller.x.value, isNot(equals(x)));
      expect(controller.y.value, isNot(equals(y)));
      await tester.pump(kThemeAnimationDuration);
    });
  });
}
