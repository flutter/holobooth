import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/rive/rive.dart';

void main() {
  group('DashAnimation', () {
    testWidgets('can update', (tester) async {
      var avatar = Avatar(
        hasMouthOpen: false,
        mouthDistance: 0,
        direction: Vector3(0, 0, 0),
        leftEyeIsClosed: false,
        rightEyeIsClosed: false,
        distance: 0.5,
      );
      var hatSelected = Hats.none;

      late StateSetter stateSetter;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              stateSetter = setState;
              return DashAnimation(
                avatar: avatar,
                hatSelected: hatSelected,
              );
            },
          ),
        ),
      );
      await tester.pump();

      final state =
          tester.state(find.byType(DashAnimation)) as DashAnimationState;
      final controller = state.dashController;
      final x = controller?.x.value;
      final y = controller?.y.value;
      final hatSelectedValue = controller?.hatSelected.value;

      stateSetter(() {
        avatar = Avatar(
          hasMouthOpen: !avatar.hasMouthOpen,
          mouthDistance: avatar.mouthDistance + 1,
          direction: Vector3(1, 1, 1),
          leftEyeIsClosed: !avatar.leftEyeIsClosed,
          rightEyeIsClosed: !avatar.rightEyeIsClosed,
          distance: avatar.distance,
        );
        hatSelected = Hats.helmet;
      });
      await tester.pump(Duration(milliseconds: 150));
      await tester.pump(Duration(milliseconds: 150));

      expect(controller?.mouthDistance.value, avatar.mouthDistance);
      expect(controller?.leftEyeIsClosed.value, 99);
      expect(controller?.rightEyeIsClosed.value, 99);
      expect(controller?.x.value, isNot(equals(x)));
      expect(controller?.y.value, isNot(equals(y)));
      expect(controller?.hatSelected.value, isNot(hatSelectedValue));
      await tester.pump(kThemeAnimationDuration);
    });
  });
}
