import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/rive/rive.dart';

void main() {
  group('BaseAnimation', () {
    testWidgets('can update', (tester) async {
      var avatar = Avatar(
        hasMouthOpen: false,
        mouthDistance: 0,
        direction: Vector3(0, 0, 0),
        leftEyeIsClosed: false,
        rightEyeIsClosed: false,
        distance: 0.5,
      );
      var selectedHat = Hats.none;
      var selectedGlasses = Glasses.none;
      var selectedClothes = Clothes.none;
      var selectedHandheldlLeft = HandheldlLeft.none;

      late StateSetter stateSetter;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              stateSetter = setState;
              return BaseCharacterAnimation(
                avatar: avatar,
                hat: selectedHat,
                glasses: selectedGlasses,
                clothes: selectedClothes,
                handheldlLeft: selectedHandheldlLeft,
                assetGenImage: Assets.animations.dash,
              );
            },
          ),
        ),
      );
      await tester.pump();

      final state = tester.state(find.byType(BaseCharacterAnimation))
          as BaseCharacterAnimationState;
      final controller = state.dashController;
      final xValue = controller?.x.value;
      final yValue = controller?.y.value;
      final hatsValue = controller?.hats.value;
      final glassesValue = controller?.glasses.value;
      final clothesValue = controller?.clothes.value;
      final handheldlLeftValue = controller?.handheldlLeft.value;

      stateSetter(() {
        avatar = Avatar(
          hasMouthOpen: !avatar.hasMouthOpen,
          mouthDistance: avatar.mouthDistance + 1,
          direction: Vector3(1, 1, 1),
          leftEyeIsClosed: !avatar.leftEyeIsClosed,
          rightEyeIsClosed: !avatar.rightEyeIsClosed,
          distance: avatar.distance,
        );
        selectedHat = Hats.helmet;
        selectedGlasses = Glasses.glasses1;
        selectedClothes = Clothes.clothes1;
        selectedHandheldlLeft = HandheldlLeft.handheldLeft1;
      });
      await tester.pump(Duration(milliseconds: 150));
      await tester.pump(Duration(milliseconds: 150));

      expect(controller?.mouthDistance.value, avatar.mouthDistance * 100);
      expect(controller?.leftEyeIsClosed.value, 99);
      expect(controller?.rightEyeIsClosed.value, 99);
      expect(controller?.x.value, isNot(equals(xValue)));
      expect(controller?.y.value, isNot(equals(yValue)));
      expect(controller?.hats.value, isNot(hatsValue));
      expect(controller?.glasses.value, isNot(glassesValue));
      expect(controller?.clothes.value, isNot(clothesValue));
      expect(
        controller?.handheldlLeft.value,
        isNot(handheldlLeftValue),
      );
      await tester.pump(kThemeAnimationDuration);
    });
  });
}
