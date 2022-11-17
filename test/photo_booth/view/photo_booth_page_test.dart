import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:collection/collection.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';
import 'package:io_photobooth/drawer_selection/bloc/drawer_selection_bloc.dart';
import 'package:io_photobooth/multiple_capture_viewer/multiple_capture_viewer.dart';
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
    when(() => cameraPlatform.dispose(any())).thenAnswer((_) async => <void>{});
    when(() => cameraPlatform.onStreamedFrameAvailable(any()))
        .thenAnswer((_) => Stream.empty());
  });

  tearDown(() {
    CameraPlatform.instance = _MockCameraPlatform();
  });

  group('PhotoBoothPage', () {
    test('is routable', () {
      expect(PhotoBoothPage.route(), isA<MaterialPageRoute<void>>());
    });

    testWidgets(
      'renders PhotoBoothView',
      (WidgetTester tester) async {
        await tester.pumpApp(PhotoBoothPage());
        await tester.pumpAndSettle();
        expect(find.byType(PhotoBoothView), findsOneWidget);
      },
    );
  });

  group('PhotoBoothView', () {
    late PhotoBoothBloc photoBoothBloc;
    late DrawerSelectionBloc drawerSelectionBloc;
    late AvatarDetectorBloc avatarDetectorBloc;

    setUp(() {
      photoBoothBloc = _MockPhotoBoothBloc();
      when(
        () => photoBoothBloc.state,
      ).thenReturn(PhotoBoothState.empty());

      drawerSelectionBloc = _MockDrawerSelectionBloc();
      when(() => drawerSelectionBloc.state).thenReturn(DrawerSelectionState());

      avatarDetectorBloc = _MockAvatarDetectorBloc();
      when(() => avatarDetectorBloc.state).thenReturn(
        AvatarDetectorDetected(
          Avatar(
            hasMouthOpen: false,
            leftEyeIsClosed: false,
            rightEyeIsClosed: false,
            direction: Vector3.zero,
          ),
        ),
      );
    });

    setUpAll(() {
      registerFallbackValue(_FakePhotoboothCameraImage());
    });

    testWidgets(
      'navigates to MultipleCaptureViewerPage when isFinished',
      (WidgetTester tester) async {
        final images = UnmodifiableListView([
          for (var i = 0; i < PhotoBoothState.totalNumberOfPhotos; i++)
            _FakePhotoboothCameraImage(),
        ]);
        whenListen(
          photoBoothBloc,
          Stream.value(PhotoBoothState(images: images)),
        );
        await tester.pumpSubject(
          PhotoBoothView(),
          photoBoothBloc: photoBoothBloc,
          drawerSelectionBloc: drawerSelectionBloc,
          avatarDetectorBloc: avatarDetectorBloc,
        );
        await tester.pumpAndSettle();
        expect(find.byType(MultipleCaptureViewerPage), findsOneWidget);
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    PhotoBoothView subject, {
    required PhotoBoothBloc photoBoothBloc,
    required DrawerSelectionBloc drawerSelectionBloc,
    required AvatarDetectorBloc avatarDetectorBloc,
  }) =>
      pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoBoothBloc),
            BlocProvider.value(value: drawerSelectionBloc),
            BlocProvider.value(value: avatarDetectorBloc),
          ],
          child: subject,
        ),
      );
}
