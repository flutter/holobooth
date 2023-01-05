import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/rive/rive.dart';
import 'package:mocktail/mocktail.dart';

class _MockLeftEyeGeometry extends Mock implements LeftEyeGeometry {}

class _MockRightEyeGeometry extends Mock implements RightEyeGeometry {}

void main() {
  group('CharacterAnimation', () {
    late RiveGenImage assetGenImage;
    late Size riveImageSize;

    setUp(() {
      assetGenImage = Assets.animations.dash;
      riveImageSize = Size(100, 100);
    });

    testWidgets('updates rotation', (tester) async {
      final initialDirection = Vector3(0, 0, 0);
      var avatar = Avatar(
        hasMouthOpen: false,
        mouthDistance: 0,
        rotation: initialDirection,
        leftEyeGeometry: LeftEyeGeometry.empty(),
        rightEyeGeometry: RightEyeGeometry.empty(),
        distance: 0.5,
      );

      late StateSetter stateSetter;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              stateSetter = setState;
              return CharacterAnimation(
                avatar: avatar,
                hat: Hats.none,
                glasses: Glasses.none,
                clothes: Clothes.none,
                handheldlLeft: HandheldlLeft.none,
                assetGenImage: assetGenImage,
                riveImageSize: riveImageSize,
              );
            },
          ),
        ),
      );
      await tester.pump();

      final state = tester.state(find.byType(CharacterAnimation))
          as CharacterAnimationState;
      final controller = state.characterController!;
      expect(controller.x.value, equals(initialDirection.x));
      expect(controller.y.value, equals(initialDirection.y));
      expect(controller.z.value, equals(initialDirection.z));

      final newDirection = Vector3(0.7, 0.7, 0.7);
      stateSetter(() {
        avatar = Avatar(
          hasMouthOpen: !avatar.hasMouthOpen,
          mouthDistance: avatar.mouthDistance + 1,
          rotation: newDirection,
          leftEyeGeometry: LeftEyeGeometry.empty(),
          rightEyeGeometry: RightEyeGeometry.empty(),
          distance: avatar.distance,
        );
      });
      await tester.pump(Duration(milliseconds: 150));
      await tester.pump(Duration(milliseconds: 150));

      expect(
        controller.x.value,
        equals(
          (newDirection.x * 100 * CharacterAnimationState.rotationScale)
              .clamp(-100, 100),
        ),
      );
      expect(
        controller.y.value,
        equals(
          (newDirection.y * 100 * CharacterAnimationState.rotationScale)
              .clamp(-100, 100),
        ),
      );
      expect(
        controller.z.value,
        equals(
          (newDirection.z * 100 * CharacterAnimationState.rotationScale)
              .clamp(-100, 100),
        ),
      );
    });

    group('mouth', () {
      testWidgets('updates', (tester) async {
        const initialMouthDistance = 0.0;
        var avatar = Avatar(
          hasMouthOpen: false,
          mouthDistance: initialMouthDistance,
          rotation: Vector3.zero,
          leftEyeGeometry: LeftEyeGeometry.empty(),
          rightEyeGeometry: RightEyeGeometry.empty(),
          distance: 0.5,
        );

        late StateSetter stateSetter;
        await tester.pumpWidget(
          MaterialApp(
            home: StatefulBuilder(
              builder: (context, setState) {
                stateSetter = setState;
                return CharacterAnimation(
                  avatar: avatar,
                  hat: Hats.none,
                  glasses: Glasses.none,
                  clothes: Clothes.none,
                  handheldlLeft: HandheldlLeft.none,
                  assetGenImage: assetGenImage,
                  riveImageSize: riveImageSize,
                );
              },
            ),
          ),
        );
        await tester.pump();

        final state = tester.state(find.byType(CharacterAnimation))
            as CharacterAnimationState;
        final controller = state.characterController!;
        expect(
          controller.mouthDistance.value,
          equals(
            initialMouthDistance * 100 * CharacterAnimationState.mouthScale,
          ),
        );

        const newMouthDistance = initialMouthDistance + .1;
        stateSetter(() {
          avatar = Avatar(
            hasMouthOpen: !avatar.hasMouthOpen,
            mouthDistance: newMouthDistance,
            rotation: Vector3.zero,
            leftEyeGeometry: LeftEyeGeometry.empty(),
            rightEyeGeometry: RightEyeGeometry.empty(),
            distance: avatar.distance,
          );
        });
        await tester.pump(Duration(milliseconds: 150));
        await tester.pump(Duration(milliseconds: 150));

        expect(
          controller.mouthDistance.value,
          equals(newMouthDistance * 100 * CharacterAnimationState.mouthScale),
        );
      });

      testWidgets('tolerates values', (tester) async {
        var mouthDistance = .0;
        var avatar = Avatar(
          hasMouthOpen: false,
          mouthDistance: mouthDistance,
          rotation: Vector3.zero,
          leftEyeGeometry: LeftEyeGeometry.empty(),
          rightEyeGeometry: RightEyeGeometry.empty(),
          distance: 0.5,
        );

        late StateSetter stateSetter;
        await tester.pumpWidget(
          MaterialApp(
            home: StatefulBuilder(
              builder: (context, setState) {
                stateSetter = setState;
                return CharacterAnimation(
                  avatar: avatar,
                  hat: Hats.none,
                  glasses: Glasses.none,
                  clothes: Clothes.none,
                  handheldlLeft: HandheldlLeft.none,
                  assetGenImage: assetGenImage,
                  riveImageSize: riveImageSize,
                );
              },
            ),
          ),
        );
        await tester.pump();

        mouthDistance = 0.1;
        stateSetter(() {
          avatar = Avatar(
            hasMouthOpen: !avatar.hasMouthOpen,
            mouthDistance: mouthDistance,
            rotation: Vector3.zero,
            leftEyeGeometry: LeftEyeGeometry.empty(),
            rightEyeGeometry: RightEyeGeometry.empty(),
            distance: avatar.distance,
          );
        });
        await tester.pump(Duration(milliseconds: 150));
        await tester.pump(Duration(milliseconds: 150));

        final state = tester.state(find.byType(CharacterAnimation))
            as CharacterAnimationState;
        final controller = state.characterController!;
        final newMouthDistance = controller.mouthDistance.value;
        mouthDistance = 0.1 -
            (CharacterAnimationState.mouthToleration /
                (CharacterAnimationState.mouthScale * 100));
        stateSetter(() {
          avatar = Avatar(
            hasMouthOpen: !avatar.hasMouthOpen,
            mouthDistance: mouthDistance,
            rotation: Vector3.zero,
            leftEyeGeometry: LeftEyeGeometry.empty(),
            rightEyeGeometry: RightEyeGeometry.empty(),
            distance: avatar.distance,
          );
        });
        await tester.pump();

        expect(
          controller.mouthDistance.value,
          equals(newMouthDistance),
        );
      });
    });

    group('left eye', () {
      testWidgets('winks', (tester) async {
        await tester.runAsync(() async {
          final openLeftEyeGeometry = _MockLeftEyeGeometry();
          when(() => openLeftEyeGeometry.population).thenReturn(200);
          when(() => openLeftEyeGeometry.isClosed).thenReturn(false);
          when(() => openLeftEyeGeometry.minRatio).thenReturn(0);
          when(() => openLeftEyeGeometry.maxRatio).thenReturn(1);
          when(() => openLeftEyeGeometry.meanRatio).thenReturn(0.5);
          when(() => openLeftEyeGeometry.distance).thenReturn(0);

          var avatar = Avatar(
            hasMouthOpen: false,
            mouthDistance: 0,
            rotation: Vector3.zero,
            leftEyeGeometry: openLeftEyeGeometry,
            rightEyeGeometry: RightEyeGeometry.empty(),
            distance: 0.5,
          );

          late StateSetter stateSetter;
          await tester.pumpWidget(
            MaterialApp(
              home: StatefulBuilder(
                builder: (context, setState) {
                  stateSetter = setState;
                  return CharacterAnimation(
                    avatar: avatar,
                    hat: Hats.none,
                    glasses: Glasses.none,
                    clothes: Clothes.none,
                    handheldlLeft: HandheldlLeft.none,
                    assetGenImage: assetGenImage,
                    riveImageSize: riveImageSize,
                  );
                },
              ),
            ),
          );
          await tester.pump();

          final state = tester.state(find.byType(CharacterAnimation))
              as CharacterAnimationState;
          final controller = state.characterController!;
          expect(controller.leftEyeIsClosed.value, equals(0));

          final winkingLeftEyeGeometry = _MockLeftEyeGeometry();
          when(() => winkingLeftEyeGeometry.population).thenReturn(200);
          when(() => winkingLeftEyeGeometry.isClosed).thenReturn(true);
          when(() => winkingLeftEyeGeometry.minRatio).thenReturn(0);
          when(() => winkingLeftEyeGeometry.maxRatio).thenReturn(1);
          when(() => winkingLeftEyeGeometry.meanRatio).thenReturn(0.5);
          when(() => winkingLeftEyeGeometry.distance).thenReturn(0.6);

          stateSetter(() {
            avatar = Avatar(
              hasMouthOpen: !avatar.hasMouthOpen,
              mouthDistance: 0,
              rotation: Vector3.zero,
              leftEyeGeometry: winkingLeftEyeGeometry,
              rightEyeGeometry: RightEyeGeometry.empty(),
              distance: avatar.distance,
            );
          });
          await tester.pump(Duration(milliseconds: 150));
          await Future<void>.delayed(CharacterAnimationState.eyeWinkDuration);

          stateSetter(() {
            avatar = Avatar(
              hasMouthOpen: !avatar.hasMouthOpen,
              mouthDistance: 0,
              rotation: Vector3.zero,
              leftEyeGeometry: winkingLeftEyeGeometry,
              rightEyeGeometry: RightEyeGeometry.empty(),
              distance: avatar.distance,
            );
          });
          await tester.pump(Duration(milliseconds: 150));
          await tester.pump(Duration(milliseconds: 150));

          expect(controller.leftEyeIsClosed.value, equals(100));
        });
      });

      testWidgets('opens after winking', (tester) async {
        await tester.runAsync(() async {
          final openLeftEyeGeometry = _MockLeftEyeGeometry();
          when(() => openLeftEyeGeometry.population).thenReturn(200);
          when(() => openLeftEyeGeometry.isClosed).thenReturn(false);
          when(() => openLeftEyeGeometry.minRatio).thenReturn(0);
          when(() => openLeftEyeGeometry.maxRatio).thenReturn(1);
          when(() => openLeftEyeGeometry.meanRatio).thenReturn(0.5);
          when(() => openLeftEyeGeometry.distance).thenReturn(0);

          var avatar = Avatar(
            hasMouthOpen: false,
            mouthDistance: 0,
            rotation: Vector3.zero,
            leftEyeGeometry: openLeftEyeGeometry,
            rightEyeGeometry: RightEyeGeometry.empty(),
            distance: 0.5,
          );

          late StateSetter stateSetter;
          await tester.pumpWidget(
            MaterialApp(
              home: StatefulBuilder(
                builder: (context, setState) {
                  stateSetter = setState;
                  return CharacterAnimation(
                    avatar: avatar,
                    hat: Hats.none,
                    glasses: Glasses.none,
                    clothes: Clothes.none,
                    handheldlLeft: HandheldlLeft.none,
                    assetGenImage: assetGenImage,
                    riveImageSize: riveImageSize,
                  );
                },
              ),
            ),
          );
          await tester.pump();

          final state = tester.state(find.byType(CharacterAnimation))
              as CharacterAnimationState;
          final controller = state.characterController!;
          expect(controller.leftEyeIsClosed.value, equals(0));

          final winkingLeftEyeGeometry = _MockLeftEyeGeometry();
          when(() => winkingLeftEyeGeometry.population).thenReturn(200);
          when(() => winkingLeftEyeGeometry.isClosed).thenReturn(true);
          when(() => winkingLeftEyeGeometry.minRatio).thenReturn(0);
          when(() => winkingLeftEyeGeometry.maxRatio).thenReturn(1);
          when(() => winkingLeftEyeGeometry.meanRatio).thenReturn(0.5);
          when(() => winkingLeftEyeGeometry.distance).thenReturn(0.6);

          stateSetter(() {
            avatar = Avatar(
              hasMouthOpen: !avatar.hasMouthOpen,
              mouthDistance: 0,
              rotation: Vector3.zero,
              leftEyeGeometry: winkingLeftEyeGeometry,
              rightEyeGeometry: RightEyeGeometry.empty(),
              distance: avatar.distance,
            );
          });
          await tester.pump(Duration(milliseconds: 150));
          await Future<void>.delayed(CharacterAnimationState.eyeWinkDuration);

          stateSetter(() {
            avatar = Avatar(
              hasMouthOpen: !avatar.hasMouthOpen,
              mouthDistance: 0,
              rotation: Vector3.zero,
              leftEyeGeometry: winkingLeftEyeGeometry,
              rightEyeGeometry: RightEyeGeometry.empty(),
              distance: avatar.distance,
            );
          });
          await tester.pump(Duration(milliseconds: 150));
          await tester.pump(Duration(milliseconds: 150));
          expect(controller.leftEyeIsClosed.value, equals(100));

          stateSetter(() {
            avatar = Avatar(
              hasMouthOpen: !avatar.hasMouthOpen,
              mouthDistance: 0,
              rotation: Vector3.zero,
              leftEyeGeometry: openLeftEyeGeometry,
              rightEyeGeometry: RightEyeGeometry.empty(),
              distance: avatar.distance,
            );
          });
          await tester.pump(Duration(milliseconds: 150));
          await tester.pump(Duration(milliseconds: 150));
          expect(controller.leftEyeIsClosed.value, equals(0));
        });
      });
    });

    testWidgets('updates right eye', (tester) async {
      final initialRightEyeGeometry = _MockRightEyeGeometry();
      when(() => initialRightEyeGeometry.population).thenReturn(0);
      when(() => initialRightEyeGeometry.isClosed).thenReturn(false);
      when(() => initialRightEyeGeometry.minRatio).thenReturn(0);
      when(() => initialRightEyeGeometry.maxRatio).thenReturn(0);
      when(() => initialRightEyeGeometry.meanRatio).thenReturn(0);
      when(() => initialRightEyeGeometry.distance).thenReturn(0);

      var avatar = Avatar(
        hasMouthOpen: false,
        mouthDistance: 0,
        rotation: Vector3.zero,
        leftEyeGeometry: LeftEyeGeometry.empty(),
        rightEyeGeometry: initialRightEyeGeometry,
        distance: 0.5,
      );

      late StateSetter stateSetter;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              stateSetter = setState;
              return CharacterAnimation(
                avatar: avatar,
                hat: Hats.none,
                glasses: Glasses.none,
                clothes: Clothes.none,
                handheldlLeft: HandheldlLeft.none,
                assetGenImage: assetGenImage,
                riveImageSize: riveImageSize,
              );
            },
          ),
        ),
      );
      await tester.pump();

      final state = tester.state(find.byType(CharacterAnimation))
          as CharacterAnimationState;
      final controller = state.characterController!;
      expect(controller.rightEyeIsClosed.value, equals(0));

      final newRightEyeGeometry = _MockRightEyeGeometry();
      when(() => newRightEyeGeometry.population).thenReturn(200);
      when(() => newRightEyeGeometry.isClosed).thenReturn(true);
      when(() => newRightEyeGeometry.minRatio).thenReturn(0);
      when(() => newRightEyeGeometry.maxRatio).thenReturn(1);
      when(() => newRightEyeGeometry.meanRatio).thenReturn(0.5);
      when(() => newRightEyeGeometry.distance).thenReturn(0.6);

      stateSetter(() {
        avatar = Avatar(
          hasMouthOpen: !avatar.hasMouthOpen,
          mouthDistance: 0,
          rotation: Vector3.zero,
          leftEyeGeometry: LeftEyeGeometry.empty(),
          rightEyeGeometry: newRightEyeGeometry,
          distance: avatar.distance,
        );
      });
      await tester.pump(Duration(milliseconds: 150));
      await tester.pump(Duration(milliseconds: 150));

      expect(
        controller.rightEyeIsClosed.value,
        equals(-20),
      );
    });

    testWidgets('updates scale', (tester) async {
      const initialDistance = 0.0;
      var avatar = Avatar(
        hasMouthOpen: false,
        mouthDistance: 0,
        rotation: Vector3.zero,
        leftEyeGeometry: LeftEyeGeometry.empty(),
        rightEyeGeometry: RightEyeGeometry.empty(),
        distance: initialDistance,
      );

      late StateSetter stateSetter;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              stateSetter = setState;
              return CharacterAnimation(
                avatar: avatar,
                hat: Hats.none,
                glasses: Glasses.none,
                clothes: Clothes.none,
                handheldlLeft: HandheldlLeft.none,
                assetGenImage: assetGenImage,
                riveImageSize: riveImageSize,
              );
            },
          ),
        ),
      );
      await tester.pump();

      final initialAnimatedScaleFinder = find.byType(AnimatedScale);
      final initialAnimatedScale =
          tester.widget<AnimatedScale>(initialAnimatedScaleFinder);
      expect(initialAnimatedScale.scale, .8);

      const newDistance = initialDistance + .2;
      stateSetter(() {
        avatar = Avatar(
          hasMouthOpen: avatar.hasMouthOpen,
          mouthDistance: avatar.mouthDistance,
          rotation: avatar.rotation,
          leftEyeGeometry: avatar.leftEyeGeometry,
          rightEyeGeometry: avatar.rightEyeGeometry,
          distance: newDistance,
        );
      });
      await tester.pump(Duration(milliseconds: 150));
      await tester.pump(Duration(milliseconds: 150));

      final newAnimatedScaleFinder = find.byType(AnimatedScale);
      final newAnimatedScale =
          tester.widget<AnimatedScale>(newAnimatedScaleFinder);
      expect(newAnimatedScale.scale, greaterThan(.8));
    });

    testWidgets('updates hat', (tester) async {
      var hat = Hats.none;
      late StateSetter stateSetter;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              stateSetter = setState;
              return CharacterAnimation(
                avatar: Avatar.zero,
                hat: hat,
                glasses: Glasses.none,
                clothes: Clothes.none,
                handheldlLeft: HandheldlLeft.none,
                assetGenImage: assetGenImage,
                riveImageSize: riveImageSize,
              );
            },
          ),
        ),
      );
      await tester.pump();

      final state = tester.state(find.byType(CharacterAnimation))
          as CharacterAnimationState;
      final controller = state.characterController!;
      expect(controller.hats.value, equals(hat.index));

      stateSetter(() {
        hat = Hats.helmet;
      });
      await tester.pump(Duration(milliseconds: 150));
      await tester.pump(Duration(milliseconds: 150));

      expect(controller.hats.value, equals(hat.index));
    });

    testWidgets('updates glasses', (tester) async {
      var glasses = Glasses.none;
      late StateSetter stateSetter;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              stateSetter = setState;
              return CharacterAnimation(
                avatar: Avatar.zero,
                hat: Hats.none,
                glasses: glasses,
                clothes: Clothes.none,
                handheldlLeft: HandheldlLeft.none,
                assetGenImage: assetGenImage,
                riveImageSize: riveImageSize,
              );
            },
          ),
        ),
      );
      await tester.pump();

      final state = tester.state(find.byType(CharacterAnimation))
          as CharacterAnimationState;
      final controller = state.characterController!;
      expect(controller.glasses.value, equals(glasses.riveIndex));

      stateSetter(() {
        glasses = Glasses.glasses1;
      });
      await tester.pump(Duration(milliseconds: 150));
      await tester.pump(Duration(milliseconds: 150));

      expect(controller.glasses.value, equals(glasses.riveIndex));
    });

    testWidgets('updates clothes', (tester) async {
      var clothes = Clothes.none;
      late StateSetter stateSetter;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              stateSetter = setState;
              return CharacterAnimation(
                avatar: Avatar.zero,
                hat: Hats.none,
                glasses: Glasses.none,
                clothes: clothes,
                handheldlLeft: HandheldlLeft.none,
                assetGenImage: assetGenImage,
                riveImageSize: riveImageSize,
              );
            },
          ),
        ),
      );
      await tester.pump();

      final state = tester.state(find.byType(CharacterAnimation))
          as CharacterAnimationState;
      final controller = state.characterController!;
      expect(controller.clothes.value, equals(clothes.index));

      stateSetter(() {
        clothes = Clothes.clothes1;
      });
      await tester.pump(Duration(milliseconds: 150));
      await tester.pump(Duration(milliseconds: 150));

      expect(controller.clothes.value, equals(clothes.index));
    });

    testWidgets('updates handheld left', (tester) async {
      var handheldLeft = HandheldlLeft.none;
      late StateSetter stateSetter;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              stateSetter = setState;
              return CharacterAnimation(
                avatar: Avatar.zero,
                hat: Hats.none,
                glasses: Glasses.none,
                clothes: Clothes.none,
                handheldlLeft: handheldLeft,
                assetGenImage: assetGenImage,
                riveImageSize: riveImageSize,
              );
            },
          ),
        ),
      );
      await tester.pump();

      final state = tester.state(find.byType(CharacterAnimation))
          as CharacterAnimationState;
      final controller = state.characterController!;
      expect(controller.handheldlLeft.value, equals(handheldLeft.index));

      stateSetter(() {
        handheldLeft = HandheldlLeft.handheldLeft1;
      });
      await tester.pump(Duration(milliseconds: 150));
      await tester.pump(Duration(milliseconds: 150));

      expect(controller.handheldlLeft.value, equals(handheldLeft.index));
    });
  });
}
