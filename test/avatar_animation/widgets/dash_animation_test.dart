import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/avatar_animation/avatar_animation.dart';

void main() {
  group('DashAnimation', () {
    testWidgets('can update', (tester) async {
      var avatar = Avatar(
        hasMouthOpen: false,
        direction: Vector3(0, 0, 0),
        leftEyeIsClosed: false,
        rightEyeIsClosed: false,
      );

      late StateSetter stateSetter;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              stateSetter = setState;
              return DashAnimation(
                avatar: avatar,
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final state =
          tester.state(find.byType(DashAnimation)) as DashAnimationState;
      final controller = state.dashController;
      expect(controller?.mouthIsOpen.value, false);
      stateSetter(
        () => avatar = Avatar(
          hasMouthOpen: !avatar.hasMouthOpen,
          direction: Vector3(0, 0, 0),
          leftEyeIsClosed: !avatar.leftEyeIsClosed,
          rightEyeIsClosed: !avatar.rightEyeIsClosed,
        ),
      );
      await tester.pump();

      expect(controller?.mouthIsOpen.value, avatar.hasMouthOpen);
      expect(controller?.leftEyeIsClosed.value, avatar.leftEyeIsClosed);
      expect(controller?.rightEyeIsClosed.value, avatar.rightEyeIsClosed);
    });
  });
}
