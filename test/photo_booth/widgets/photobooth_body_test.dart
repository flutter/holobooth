import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockCameraPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CameraPlatform {}

class _MockCameraDescription extends Mock implements CameraDescription {}

class _MockXFile extends Mock implements XFile {}

class _MockPhotoBoothBloc extends MockBloc<PhotoBoothEvent, PhotoBoothState>
    implements PhotoBoothBloc {}

class _MockInExperienceSelectionBloc
    extends MockBloc<InExperienceSelectionEvent, InExperienceSelectionState>
    implements InExperienceSelectionBloc {}

class _MockAvatarDetectorBloc
    extends MockBloc<AvatarDetectorEvent, AvatarDetectorState>
    implements AvatarDetectorBloc {}

void main() {
  group('PhotoboothBody', () {
    late AvatarDetectorBloc avatarDetectorBloc;
    late PhotoBoothBloc photoBoothBloc;
    late InExperienceSelectionBloc inExperienceSelectionBloc;
    const cameraId = 1;
    late CameraPlatform cameraPlatform;
    late XFile xfile;

    setUp(() {
      xfile = _MockXFile();
      when(() => xfile.path).thenReturn('');

      cameraPlatform = _MockCameraPlatform();
      CameraPlatform.instance = cameraPlatform;

      final event = CameraInitializedEvent(
        cameraId,
        1,
        1,
        ExposureMode.auto,
        true,
        FocusMode.auto,
        true,
      );

      final cameraDescription = _MockCameraDescription();
      when(() => cameraPlatform.availableCameras())
          .thenAnswer((_) async => [cameraDescription]);
      when(
        () => cameraPlatform.createCamera(
          cameraDescription,
          ResolutionPreset.high,
        ),
      ).thenAnswer((_) async => 1);
      when(() => cameraPlatform.initializeCamera(cameraId))
          .thenAnswer((_) async => <void>{});
      when(() => cameraPlatform.onCameraInitialized(cameraId)).thenAnswer(
        (_) => Stream.value(event),
      );
      when(() => CameraPlatform.instance.onDeviceOrientationChanged())
          .thenAnswer((_) => Stream.empty());
      when(() => cameraPlatform.takePicture(any()))
          .thenAnswer((_) async => xfile);
      when(() => cameraPlatform.buildPreview(cameraId)).thenReturn(SizedBox());
      when(() => cameraPlatform.pausePreview(cameraId))
          .thenAnswer((_) => Future.value());
      when(() => cameraPlatform.dispose(any()))
          .thenAnswer((_) async => <void>{});
      when(() => cameraPlatform.onStreamedFrameAvailable(any()))
          .thenAnswer((_) => Stream.empty());

      photoBoothBloc = _MockPhotoBoothBloc();
      when(
        () => photoBoothBloc.state,
      ).thenReturn(PhotoBoothState());

      inExperienceSelectionBloc = _MockInExperienceSelectionBloc();
      when(() => inExperienceSelectionBloc.state)
          .thenReturn(InExperienceSelectionState());

      avatarDetectorBloc = _MockAvatarDetectorBloc();
      when(() => avatarDetectorBloc.state).thenReturn(
        AvatarDetectorState(status: AvatarDetectorStatus.loaded),
      );
    });

    tearDown(() {
      CameraPlatform.instance = _MockCameraPlatform();
    });

    group('renders', () {
      testWidgets(
        'PhotoboothError if any CameraException finding camera',
        (WidgetTester tester) async {
          when(() => cameraPlatform.availableCameras())
              .thenThrow(CameraException('', ''));
          await tester.pumpSubject(
            PhotoboothBody(),
            inExperienceSelectionBloc: inExperienceSelectionBloc,
            photoBoothBloc: photoBoothBloc,
            avatarDetectorBloc: avatarDetectorBloc,
          );
          await tester.pump();

          expect(find.byType(CameraErrorView), findsOneWidget);
        },
      );
    });

    testWidgets(
      'adds PhotoBoothRecordingFinished when onCountdownCompleted is called',
      (WidgetTester tester) async {
        await tester.pumpSubject(
          PhotoboothBody(),
          inExperienceSelectionBloc: inExperienceSelectionBloc,
          photoBoothBloc: photoBoothBloc,
          avatarDetectorBloc: avatarDetectorBloc,
        );
        await tester.pump();
        final shutterButton = tester.widget<ShutterButton>(
          find.byType(ShutterButton),
        );

        shutterButton.onCountdownCompleted();
        await tester.pump();
        verify(() => photoBoothBloc.add(PhotoBoothRecordingFinished(const [])))
            .called(1);
      },
    );

    testWidgets(
      'adds PhotoBoothRecordingStarted when onCountdownStarted is called',
      (WidgetTester tester) async {
        await tester.pumpSubject(
          PhotoboothBody(),
          inExperienceSelectionBloc: inExperienceSelectionBloc,
          photoBoothBloc: photoBoothBloc,
          avatarDetectorBloc: avatarDetectorBloc,
        );
        await tester.pump();
        final shutterButton = tester.widget<ShutterButton>(
          find.byType(ShutterButton),
        );

        shutterButton.onCountdownStarted();
        await tester.pump();
        verify(() => photoBoothBloc.add(PhotoBoothRecordingStarted()))
            .called(1);
      },
    );

    testWidgets(
      'renders RecordingLayer if PhotoBoothState.isRecording',
      (WidgetTester tester) async {
        when(() => photoBoothBloc.state)
            .thenReturn(PhotoBoothState().copyWith(isRecording: true));
        await tester.pumpSubject(
          PhotoboothBody(),
          photoBoothBloc: photoBoothBloc,
          inExperienceSelectionBloc: inExperienceSelectionBloc,
          avatarDetectorBloc: avatarDetectorBloc,
        );
        expect(find.byType(RecordingLayer), findsOneWidget);
      },
    );

    testWidgets(
      'renders SelectionLayer if not PhotoBoothState.isRecording',
      (WidgetTester tester) async {
        when(() => photoBoothBloc.state).thenReturn(PhotoBoothState());
        await tester.pumpSubject(
          PhotoboothBody(),
          photoBoothBloc: photoBoothBloc,
          inExperienceSelectionBloc: inExperienceSelectionBloc,
          avatarDetectorBloc: avatarDetectorBloc,
        );
        expect(find.byType(SelectionLayer), findsOneWidget);
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    PhotoboothBody subject, {
    required PhotoBoothBloc photoBoothBloc,
    required InExperienceSelectionBloc inExperienceSelectionBloc,
    required AvatarDetectorBloc avatarDetectorBloc,
  }) =>
      pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoBoothBloc),
            BlocProvider.value(value: inExperienceSelectionBloc),
            BlocProvider.value(value: avatarDetectorBloc),
          ],
          child: Scaffold(body: subject),
        ),
      );
}
