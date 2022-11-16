import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/rive/rive.dart';

void main() {
  group('SpaceBackground', () {
    testWidgets('udpates x and y when position changes', (tester) async {
      late StateSetter stateSetter;
      var vector3 = Vector3.zero;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              stateSetter = setState;
              return SpaceBackground.fromVector3(vector3);
            },
          ),
        ),
      );
      await tester.pump();

      final state =
          tester.state(find.byType(SpaceBackground)) as SpaceBackgroundState;
      final controller = state.backgroundController!;

      final x = controller.x.value;
      final y = controller.y.value;

      stateSetter(() => vector3 = Vector3(1, 1, 1));
      await tester.pump();

      expect(controller.x.value, isNot(equals(x)));
      expect(controller.y.value, isNot(equals(y)));
    });
  });
}
