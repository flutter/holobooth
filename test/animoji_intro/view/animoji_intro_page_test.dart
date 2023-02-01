import 'package:bloc_test/bloc_test.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart'
    hide CameraEvent;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/animoji_intro/animoji_intro.dart';
import 'package:holobooth/camera/bloc/camera_bloc.dart';
import 'package:holobooth/photo_booth/photo_booth.dart';
import 'package:holobooth_ui/holobooth_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockCameraPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CameraPlatform {}

class _MockCameraBloc extends MockBloc<CameraEvent, CameraState>
    implements CameraBloc {}

void main() {
  final cameraPlatform = _MockCameraPlatform();
  CameraPlatform.instance = cameraPlatform;

  final cameraBloc = _MockCameraBloc();
  final camerasStub = [
    CameraDescription(
      name: 'Camera 1',
      lensDirection: CameraLensDirection.front,
      sensorOrientation: 0,
    ),
    CameraDescription(
      name: 'Camera 2',
      lensDirection: CameraLensDirection.front,
      sensorOrientation: 0,
    ),
  ];

  group('AnimojiIntroPage', () {
    testWidgets('renders AnimojiIntroView', (tester) async {
      await tester.pumpApp(AnimojiIntroPage());
      expect(find.byType(AnimojiIntroView), findsOneWidget);
    });
  });

  group('AnimojiIntroView', () {
    testWidgets('renders background', (tester) async {
      await tester.pumpApp(const AnimojiIntroView());
      expect(find.byType(AnimojiIntroBackground), findsOneWidget);
    });

    testWidgets('renders subheading', (tester) async {
      await tester.pumpApp(const AnimojiIntroView());
      expect(find.byKey(Key('animojiIntro_subheading_text')), findsOneWidget);
    });

    testWidgets('renders animation', (tester) async {
      await tester.pumpApp(const AnimojiIntroView());
      expect(find.byType(AnimatedSprite), findsOneWidget);
      final widget = tester.widget<AnimatedSprite>(find.byType(AnimatedSprite));
      expect(widget.sprites.asset, equals('holobooth_avatar.png'));
    });

    testWidgets('renders AnimojiNextButton', (tester) async {
      await tester.pumpApp(const AnimojiIntroView());
      expect(find.byType(AnimojiNextButton), findsOneWidget);
    });

    testWidgets('tapping on AnimojiNextButton navigates to PhotoBoothPage',
        (tester) async {
      await tester.pumpApp(const AnimojiIntroView());
      await tester.ensureVisible(find.byType(AnimojiNextButton));
      await tester.pump();
      await tester.tap(
        find.byType(
          AnimojiNextButton,
          skipOffstage: false,
        ),
      );
      await tester.pump(kThemeAnimationDuration);
      await tester.pump(kThemeAnimationDuration);
      await tester.pump(kThemeAnimationDuration);

      expect(find.byType(PhotoBoothPage), findsOneWidget);
      expect(find.byType(AnimojiIntroPage), findsNothing);
    });

    testWidgets(
        'renders CircularProgressIndicator while availableCameras() is running',
        (tester) async {
      await tester.pumpApp(const AnimojiIntroView());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders no camera icon when available cameras list is empty',
        (tester) async {
      when(cameraPlatform.availableCameras).thenAnswer((_) async => []);

      await tester.pumpApp(const AnimojiIntroView());
      await tester.pump();

      expect(find.byKey(Key('animojiIntro_no_camera_icon')), findsOneWidget);
    });

    testWidgets('renders error view when availableCameras throws an error',
        (tester) async {
      when(cameraPlatform.availableCameras).thenThrow(CameraException('', ''));

      await tester.pumpApp(const AnimojiIntroView());
      await tester.pump();

      expect(find.byKey(Key('animojiIntro_camera_error_view')), findsOneWidget);
    });

    group('Cameras dropdown', () {
      setUp(() {
        when(cameraPlatform.availableCameras)
            .thenAnswer((_) async => camerasStub);
        when(() => cameraBloc.state)
            .thenReturn(CameraState(camera: camerasStub[0]));
      });

      testWidgets('displays dropdown button with the list of available cameras',
          (tester) async {
        await tester.pumpApp(const AnimojiIntroView());
        await tester.pump();

        expect(find.byType(DropdownButton<CameraDescription>), findsOneWidget);

        for (var i = 0; i < camerasStub.length; i++) {
          expect(find.text(camerasStub[i].name), findsOneWidget);
        }
      });

      testWidgets('emits camera change event when dropdown value changes',
          (tester) async {
        await tester.pumpApp(const AnimojiIntroView(), cameraBloc: cameraBloc);
        await tester.pump();

        await tester.tap(find.byType(DropdownButton<CameraDescription>));
        await tester.pumpAndSettle();

        await tester.tap(find.text(camerasStub[1].name).last);
        await tester.pumpAndSettle();

        verify(() => cameraBloc.add(CameraChanged(camerasStub[1]))).called(1);
      });
    });
  });
}
