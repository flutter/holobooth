import 'package:bloc_test/bloc_test.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';
import 'package:io_photobooth/drawer_selection/drawer_selection.dart';
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

class _MockDrawerSelectionBloc
    extends MockBloc<DrawerSelectionEvent, DrawerSelectionState>
    implements DrawerSelectionBloc {}

class _MockAvatarDetectorBloc
    extends MockBloc<AvatarDetectorEvent, AvatarDetectorState>
    implements AvatarDetectorBloc {}

class _FakePhotoboothCameraImage extends Fake implements PhotoboothCameraImage {
  @override
  String get data => '';

  @override
  PhotoConstraint get constraint => PhotoConstraint();
}

void main() {
  group('PhotoboothBody', () {
    late AvatarDetectorBloc avatarDetectorBloc;
    late PhotoBoothBloc photoBoothBloc;
    late DrawerSelectionBloc drawerSelectionBloc;
    const cameraId = 1;
    late CameraPlatform cameraPlatform;
    late XFile xfile;
    late PhotoboothCameraImage image;

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

      image = PhotoboothCameraImage(
        data: xfile.path,
        constraint: PhotoConstraint(
          width: event.previewWidth,
          height: event.previewHeight,
        ),
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
      ).thenReturn(PhotoBoothState.empty());

      drawerSelectionBloc = _MockDrawerSelectionBloc();
      when(() => drawerSelectionBloc.state).thenReturn(DrawerSelectionState());

      avatarDetectorBloc = _MockAvatarDetectorBloc();
      when(() => avatarDetectorBloc.state).thenReturn(
        AvatarDetectorState(status: AvatarDetectorStatus.loaded),
      );
    });

    tearDown(() {
      CameraPlatform.instance = _MockCameraPlatform();
    });

    setUpAll(() {
      registerFallbackValue(_FakePhotoboothCameraImage());
    });

    group('renders', () {
      testWidgets(
        'empty SizedBox if any unexpected error finding camera',
        (WidgetTester tester) async {
          when(() => cameraPlatform.availableCameras()).thenThrow(Exception());
          await tester.pumpSubject(
            PhotoboothBody(),
            drawerSelectionBloc: drawerSelectionBloc,
            photoBoothBloc: photoBoothBloc,
            avatarDetectorBloc: avatarDetectorBloc,
          );
          await tester.pump();

          expect(
            find.byKey(PhotoboothBody.cameraErrorViewKey),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'PhotoboothError if any CameraException finding camera',
        (WidgetTester tester) async {
          when(() => cameraPlatform.availableCameras())
              .thenThrow(CameraException('', ''));
          await tester.pumpSubject(
            PhotoboothBody(),
            drawerSelectionBloc: drawerSelectionBloc,
            photoBoothBloc: photoBoothBloc,
            avatarDetectorBloc: avatarDetectorBloc,
          );
          await tester.pump();

          expect(find.byType(PhotoboothError), findsOneWidget);
        },
      );

      testWidgets('renders SelectionButtons', (tester) async {
        await tester.pumpSubject(
          PhotoboothBody(),
          drawerSelectionBloc: drawerSelectionBloc,
          photoBoothBloc: photoBoothBloc,
          avatarDetectorBloc: avatarDetectorBloc,
        );
        await tester.pump();

        expect(
          find.byType(SelectionButtons),
          findsOneWidget,
        );
      });
    });

    testWidgets(
      'adds PhotoBoothOnPhotoTaken when onShutter is called',
      (WidgetTester tester) async {
        await tester.pumpSubject(
          PhotoboothBody(),
          drawerSelectionBloc: drawerSelectionBloc,
          photoBoothBloc: photoBoothBloc,
          avatarDetectorBloc: avatarDetectorBloc,
        );
        await tester.pump();
        final multipleShutterButton = tester.widget<MultipleShutterButton>(
          find.byType(MultipleShutterButton),
        );

        await multipleShutterButton.onShutter();
        await tester.pump();
        verify(
          () => photoBoothBloc.add(
            PhotoBoothOnPhotoTaken(
              image: image,
            ),
          ),
        ).called(1);
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    PhotoboothBody subject, {
    required PhotoBoothBloc photoBoothBloc,
    required DrawerSelectionBloc drawerSelectionBloc,
    required AvatarDetectorBloc avatarDetectorBloc,
  }) =>
      pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: photoBoothBloc,
            ),
            BlocProvider.value(
              value: drawerSelectionBloc,
            ),
            BlocProvider.value(
              value: avatarDetectorBloc,
            ),
          ],
          child: subject,
        ),
      );
}
