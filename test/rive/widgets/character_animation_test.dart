import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/in_experience_selection/in_experience_selection.dart';
import 'package:holobooth/rive/rive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform_helper/platform_helper.dart';
import 'package:rive/rive.dart';

import '../../helpers/helpers.dart';

class _MockLeftEyeGeometry extends Mock implements LeftEyeGeometry {}

class _MockRightEyeGeometry extends Mock implements RightEyeGeometry {}

class _MockPlatformHelper extends Mock implements PlatformHelper {}

class _FakePlatformHelper extends Fake implements PlatformHelper {
  _FakePlatformHelper({required this.isMobile});

  @override
  final bool isMobile;
}

class _FakeRiveFileManager extends Fake implements RiveFileManager {
  @override
  Future<RiveFile> loadFile(String assetPath) {
    return RiveFile.asset(assetPath);
  }
}

Finder _findCharacterAnimation(
  RiveCharacter riveCharacter,
) =>
    find.byWidgetPredicate(
      (widget) =>
          widget is RiveAnimation && widget.file == riveCharacter.riveFile,
    );

void main() {
  late PlatformHelper platformHelper;

  setUp(() => platformHelper = _MockPlatformHelper());

  testWidgets('renders placeholder', (tester) async {
    when(() => platformHelper.isMobile).thenReturn(true);

    await tester.pumpApp(
      CharacterAnimation(
        avatar: Avatar.zero,
        hat: Hats.none,
        glasses: Glasses.none,
        clothes: Clothes.none,
        handheldlLeft: HandheldlLeft.none,
        riveCharacter: RiveCharacter.dash(platformHelper),
      ),
    );

    expect(find.byKey(Key('characterAnimation_placeholder')), findsOneWidget);
  });

  group('with RiveCharacter.dash', () {
    testWidgets(
      'renders mobile asset',
      (WidgetTester tester) async {
        when(() => platformHelper.isMobile).thenReturn(true);
        final character = RiveCharacter.dash(platformHelper);
        await character.load(_FakeRiveFileManager());

        await tester.pumpApp(
          CharacterAnimation(
            avatar: Avatar.zero,
            hat: Hats.none,
            glasses: Glasses.none,
            clothes: Clothes.none,
            handheldlLeft: HandheldlLeft.none,
            riveCharacter: character,
          ),
        );

        final widgetFinder = _findCharacterAnimation(character);

        expect(widgetFinder, findsOneWidget);
        expect(
          character.riveFilePath,
          equals(Assets.animations.dashMobile.path),
        );
      },
    );

    testWidgets(
      'renders desktop asset',
      (WidgetTester tester) async {
        when(() => platformHelper.isMobile).thenReturn(false);
        final character = RiveCharacter.dash(platformHelper);
        await character.load(_FakeRiveFileManager());

        await tester.pumpApp(
          CharacterAnimation(
            avatar: Avatar.zero,
            hat: Hats.none,
            glasses: Glasses.none,
            clothes: Clothes.none,
            handheldlLeft: HandheldlLeft.none,
            riveCharacter: character,
          ),
        );

        final widgetFinder = _findCharacterAnimation(character);

        expect(widgetFinder, findsOneWidget);
        expect(
          character.riveFilePath,
          equals(Assets.animations.dashDesktop.path),
        );
      },
    );
  });

  group('with RiveCharacter.sparky', () {
    testWidgets(
      'renders mobile asset',
      (WidgetTester tester) async {
        when(() => platformHelper.isMobile).thenReturn(true);
        final character = RiveCharacter.sparky(platformHelper);
        await character.load(_FakeRiveFileManager());

        await tester.pumpApp(
          CharacterAnimation(
            avatar: Avatar.zero,
            hat: Hats.none,
            glasses: Glasses.none,
            clothes: Clothes.none,
            handheldlLeft: HandheldlLeft.none,
            riveCharacter: character,
          ),
        );

        final widgetFinder = _findCharacterAnimation(character);

        expect(widgetFinder, findsOneWidget);
        expect(
          character.riveFilePath,
          equals(Assets.animations.sparkyMobile.path),
        );
      },
    );

    testWidgets(
      'renders desktop asset',
      (WidgetTester tester) async {
        when(() => platformHelper.isMobile).thenReturn(false);
        final character = RiveCharacter.sparky(platformHelper);
        await character.load(_FakeRiveFileManager());

        await tester.pumpApp(
          CharacterAnimation(
            avatar: Avatar.zero,
            hat: Hats.none,
            glasses: Glasses.none,
            clothes: Clothes.none,
            handheldlLeft: HandheldlLeft.none,
            riveCharacter: character,
          ),
        );

        final widgetFinder = _findCharacterAnimation(character);

        expect(widgetFinder, findsOneWidget);
        expect(
          character.riveFilePath,
          equals(Assets.animations.sparkyDesktop.path),
        );
      },
    );
  });

  group('CharacterAnimation', () {
    late RiveCharacter riveCharacter;

    setUp(() async {
      riveCharacter = RiveCharacter.dash(_FakePlatformHelper(isMobile: true));
      await riveCharacter.load(_FakeRiveFileManager());
    });

    group('rotation', () {
      testWidgets('updates', (tester) async {
        final initialRotation = Vector3(0, 0, 0);
        var avatar = Avatar(
          hasMouthOpen: false,
          mouthDistance: 0,
          rotation: initialRotation,
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
                  riveCharacter: riveCharacter,
                );
              },
            ),
          ),
        );
        await tester.pump();

        final state = tester.state(find.byType(CharacterAnimation))
            as CharacterAnimationState;
        final controller = state.characterController!;
        expect(controller.x.value, equals(initialRotation.x));
        expect(controller.y.value, equals(initialRotation.y));
        expect(controller.z.value, equals(initialRotation.z));

        const tolerationBoundary = CharacterAnimationState.rotationToleration /
            (100 * CharacterAnimationState.rotationScale);
        final newRotation = Vector3(
          initialRotation.x + tolerationBoundary,
          initialRotation.y + tolerationBoundary,
          initialRotation.z + tolerationBoundary,
        );
        stateSetter(() {
          avatar = Avatar(
            hasMouthOpen: !avatar.hasMouthOpen,
            mouthDistance: avatar.mouthDistance + 1,
            rotation: newRotation,
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
            (newRotation.x * 100 * CharacterAnimationState.rotationScale)
                .clamp(-100, 100),
          ),
        );
        expect(
          controller.y.value,
          equals(
            (newRotation.y * 100 * CharacterAnimationState.rotationScale)
                .clamp(-100, 100),
          ),
        );
        expect(
          controller.z.value,
          equals(
            (newRotation.z * 100 * CharacterAnimationState.rotationScale)
                .clamp(-100, 100),
          ),
        );
      });

      testWidgets('tolerates', (tester) async {
        final initialRotation = Vector3(0, 0, 0);
        var avatar = Avatar(
          hasMouthOpen: false,
          mouthDistance: 0,
          rotation: initialRotation,
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
                  riveCharacter: riveCharacter,
                );
              },
            ),
          ),
        );
        await tester.pump();

        final state = tester.state(find.byType(CharacterAnimation))
            as CharacterAnimationState;
        final controller = state.characterController!;
        expect(controller.x.value, equals(initialRotation.x));
        expect(controller.y.value, equals(initialRotation.y));
        expect(controller.z.value, equals(initialRotation.z));

        const tolerationBoundary = (CharacterAnimationState.rotationToleration /
                (100 * CharacterAnimationState.rotationScale)) -
            0.01;
        final newRotation = Vector3(
          initialRotation.x + tolerationBoundary,
          initialRotation.y + tolerationBoundary,
          initialRotation.z + tolerationBoundary,
        );
        stateSetter(() {
          avatar = Avatar(
            hasMouthOpen: !avatar.hasMouthOpen,
            mouthDistance: avatar.mouthDistance + 1,
            rotation: newRotation,
            leftEyeGeometry: LeftEyeGeometry.empty(),
            rightEyeGeometry: RightEyeGeometry.empty(),
            distance: avatar.distance,
          );
        });
        await tester.pump(Duration(milliseconds: 150));
        await tester.pump(Duration(milliseconds: 150));

        expect(controller.x.value, equals(initialRotation.x));
        expect(controller.y.value, equals(initialRotation.y));
        expect(controller.z.value, equals(initialRotation.z));
      });
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
                  riveCharacter: riveCharacter,
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

      testWidgets('tolerates', (tester) async {
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
                  riveCharacter: riveCharacter,
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
      late LeftEyeGeometry openLeftEyeGeometry;
      late LeftEyeGeometry winkingLeftEyeGeometry;

      setUp(() {
        openLeftEyeGeometry = _MockLeftEyeGeometry();
        when(() => openLeftEyeGeometry.population).thenReturn(200);
        when(() => openLeftEyeGeometry.isClosed).thenReturn(false);
        when(() => openLeftEyeGeometry.minRatio).thenReturn(0);
        when(() => openLeftEyeGeometry.maxRatio).thenReturn(1);
        when(() => openLeftEyeGeometry.meanRatio).thenReturn(0.5);
        when(() => openLeftEyeGeometry.distance).thenReturn(0);

        winkingLeftEyeGeometry = _MockLeftEyeGeometry();
        when(() => winkingLeftEyeGeometry.population).thenReturn(200);
        when(() => winkingLeftEyeGeometry.isClosed).thenReturn(true);
        when(() => winkingLeftEyeGeometry.minRatio).thenReturn(0);
        when(() => winkingLeftEyeGeometry.maxRatio).thenReturn(1);
        when(() => winkingLeftEyeGeometry.meanRatio).thenReturn(0.5);
        when(() => winkingLeftEyeGeometry.distance).thenReturn(0.6);
      });

      testWidgets('winks', (tester) async {
        await tester.runAsync(() async {
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
                    riveCharacter: riveCharacter,
                  );
                },
              ),
            ),
          );
          await tester.pump();

          final state = tester.state(find.byType(CharacterAnimation))
              as CharacterAnimationState;
          final controller = state.characterController!;
          expect(controller.leftEye.value, equals(0));

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

          expect(controller.leftEye.value, equals(100));
        });
      });

      testWidgets('opens after winking', (tester) async {
        await tester.runAsync(() async {
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
                    riveCharacter: riveCharacter,
                  );
                },
              ),
            ),
          );
          await tester.pump();

          final state = tester.state(find.byType(CharacterAnimation))
              as CharacterAnimationState;
          final controller = state.characterController!;
          expect(controller.leftEye.value, equals(0));

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
          expect(controller.leftEye.value, equals(100));

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
          expect(controller.leftEye.value, equals(0));
        });
      });
    });

    group('right eye', () {
      late RightEyeGeometry openRightEyeGeometry;
      late RightEyeGeometry winkingRightEyeGeometry;

      setUp(() {
        openRightEyeGeometry = _MockRightEyeGeometry();
        when(() => openRightEyeGeometry.population).thenReturn(200);
        when(() => openRightEyeGeometry.isClosed).thenReturn(false);
        when(() => openRightEyeGeometry.minRatio).thenReturn(0);
        when(() => openRightEyeGeometry.maxRatio).thenReturn(1);
        when(() => openRightEyeGeometry.meanRatio).thenReturn(0.5);
        when(() => openRightEyeGeometry.distance).thenReturn(0);

        winkingRightEyeGeometry = _MockRightEyeGeometry();
        when(() => winkingRightEyeGeometry.population).thenReturn(200);
        when(() => winkingRightEyeGeometry.isClosed).thenReturn(true);
        when(() => winkingRightEyeGeometry.minRatio).thenReturn(0);
        when(() => winkingRightEyeGeometry.maxRatio).thenReturn(1);
        when(() => winkingRightEyeGeometry.meanRatio).thenReturn(0.5);
        when(() => winkingRightEyeGeometry.distance).thenReturn(0.6);
      });

      testWidgets('winks', (tester) async {
        await tester.runAsync(() async {
          var avatar = Avatar(
            hasMouthOpen: false,
            mouthDistance: 0,
            rotation: Vector3.zero,
            leftEyeGeometry: LeftEyeGeometry.empty(),
            rightEyeGeometry: openRightEyeGeometry,
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
                    riveCharacter: riveCharacter,
                  );
                },
              ),
            ),
          );
          await tester.pump();

          final state = tester.state(find.byType(CharacterAnimation))
              as CharacterAnimationState;
          final controller = state.characterController!;
          expect(controller.rightEye.value, equals(0));

          stateSetter(() {
            avatar = Avatar(
              hasMouthOpen: !avatar.hasMouthOpen,
              mouthDistance: 0,
              rotation: Vector3.zero,
              leftEyeGeometry: LeftEyeGeometry.empty(),
              rightEyeGeometry: winkingRightEyeGeometry,
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
              leftEyeGeometry: LeftEyeGeometry.empty(),
              rightEyeGeometry: winkingRightEyeGeometry,
              distance: avatar.distance,
            );
          });
          await tester.pump(Duration(milliseconds: 150));
          await tester.pump(Duration(milliseconds: 150));
          expect(controller.rightEye.value, equals(100));
        });
      });

      testWidgets('opens after winking', (tester) async {
        await tester.runAsync(() async {
          var avatar = Avatar(
            hasMouthOpen: false,
            mouthDistance: 0,
            rotation: Vector3.zero,
            leftEyeGeometry: LeftEyeGeometry.empty(),
            rightEyeGeometry: openRightEyeGeometry,
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
                    riveCharacter: riveCharacter,
                  );
                },
              ),
            ),
          );
          await tester.pump();

          final state = tester.state(find.byType(CharacterAnimation))
              as CharacterAnimationState;
          final controller = state.characterController!;
          expect(controller.rightEye.value, equals(0));

          stateSetter(() {
            avatar = Avatar(
              hasMouthOpen: !avatar.hasMouthOpen,
              mouthDistance: 0,
              rotation: Vector3.zero,
              leftEyeGeometry: LeftEyeGeometry.empty(),
              rightEyeGeometry: winkingRightEyeGeometry,
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
              leftEyeGeometry: LeftEyeGeometry.empty(),
              rightEyeGeometry: winkingRightEyeGeometry,
              distance: avatar.distance,
            );
          });
          await tester.pump(Duration(milliseconds: 150));
          await tester.pump(Duration(milliseconds: 150));
          expect(controller.rightEye.value, equals(100));

          stateSetter(() {
            avatar = Avatar(
              hasMouthOpen: !avatar.hasMouthOpen,
              mouthDistance: 0,
              rotation: Vector3.zero,
              leftEyeGeometry: LeftEyeGeometry.empty(),
              rightEyeGeometry: openRightEyeGeometry,
              distance: avatar.distance,
            );
          });
          await tester.pump(Duration(milliseconds: 150));
          await tester.pump(Duration(milliseconds: 150));
          expect(controller.rightEye.value, equals(0));
        });
      });
    });

    group('scale', () {
      testWidgets('updates', (tester) async {
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
                  riveCharacter: riveCharacter,
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

        final newDistance = ((initialAnimatedScale.scale +
                    CharacterAnimationState.scaleToleration +
                    0.01) -
                0.8) /
            (5 - 0.8);
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

      testWidgets('tolerates', (tester) async {
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
                  riveCharacter: riveCharacter,
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

        final newDistance = ((initialAnimatedScale.scale +
                    CharacterAnimationState.scaleToleration) -
                0.8) /
            (5 - 0.8);
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
        expect(newAnimatedScale.scale, initialAnimatedScale.scale);
      });
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
                riveCharacter: riveCharacter,
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
        hat = Hats.hat01;
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
                riveCharacter: riveCharacter,
              );
            },
          ),
        ),
      );
      await tester.pump();

      final state = tester.state(find.byType(CharacterAnimation))
          as CharacterAnimationState;
      final controller = state.characterController!;
      expect(controller.glasses.value, equals(glasses.index));

      stateSetter(() {
        glasses = Glasses.glasses01;
      });
      await tester.pump(Duration(milliseconds: 150));
      await tester.pump(Duration(milliseconds: 150));

      expect(controller.glasses.value, equals(glasses.index));
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
                riveCharacter: riveCharacter,
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
        clothes = Clothes.shirt01;
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
                riveCharacter: riveCharacter,
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
        handheldLeft = HandheldlLeft.handheld01;
      });
      await tester.pump(Duration(milliseconds: 150));
      await tester.pump(Duration(milliseconds: 150));

      expect(controller.handheldlLeft.value, equals(handheldLeft.index));
    });
  });
}
