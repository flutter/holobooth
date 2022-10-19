import 'package:bloc_test/bloc_test.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/multiple_capture/multiple_capture.dart';
import 'package:io_photobooth/multiple_capture_viewer/multiple_capture_viewer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockCameraPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CameraPlatform {}

class _MockCameraDescription extends Mock implements CameraDescription {}

class _MockXFile extends Mock implements XFile {}

class _MockMultipleCaptureBloc
    extends MockBloc<MultipleCaptureEvent, MultipleCaptureState>
    implements MultipleCaptureBloc {}

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
        ResolutionPreset.max,
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
  });

  tearDown(() {
    CameraPlatform.instance = _MockCameraPlatform();
  });

  group('MultipleCapturePage', () {
    test('is routable', () {
      expect(MultipleCapturePage.route(), isA<MaterialPageRoute<void>>());
    });

    testWidgets(
      'renders MultipleCaptureView',
      (WidgetTester tester) async {
        await tester.pumpApp(MultipleCapturePage());
      },
    );
  });

  group('MultipleCaptureView', () {
    late MultipleCaptureBloc multipleCaptureBloc;

    setUp(() {
      multipleCaptureBloc = _MockMultipleCaptureBloc();
      when(
        () => multipleCaptureBloc.state,
      ).thenReturn(MultipleCaptureState.empty());
    });

    setUpAll(() {
      registerFallbackValue(_FakePhotoboothCameraImage());
    });

    testWidgets(
      'renders empty SizedBox if any unexpected error finding camera',
      (WidgetTester tester) async {
        when(() => cameraPlatform.availableCameras()).thenThrow(Exception());
        await tester.pumpSubject(MultipleCaptureView(), multipleCaptureBloc);
        await tester.pumpAndSettle();
        expect(
          find.byKey(MultipleCaptureView.cameraErrorViewKey),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders PhotoboothError if any CameraException finding camera',
      (WidgetTester tester) async {
        when(() => cameraPlatform.availableCameras())
            .thenThrow(CameraException('', ''));
        await tester.pumpSubject(MultipleCaptureView(), multipleCaptureBloc);
        await tester.pumpAndSettle();
        expect(find.byType(PhotoboothError), findsOneWidget);
      },
    );

    testWidgets(
      'navigates to MultipleCaptureViewerPage when isFinished',
      (WidgetTester tester) async {
        final images = UnmodifiableListView([
          for (var i = 0; i < MultipleCaptureState.totalNumberOfPhotos; i++)
            _FakePhotoboothCameraImage(),
        ]);
        whenListen(
          multipleCaptureBloc,
          Stream.value(MultipleCaptureState(images: images)),
        );
        await tester.pumpSubject(MultipleCaptureView(), multipleCaptureBloc);
        await tester.pumpAndSettle();
        expect(find.byType(MultipleCaptureViewerPage), findsOneWidget);
      },
    );

    testWidgets(
      'adds MultipleCaptureOnPhotoTaken when onShutter is called',
      (WidgetTester tester) async {
        await tester.pumpSubject(MultipleCaptureView(), multipleCaptureBloc);
        await tester.pumpAndSettle();
        final multipleShutterButton = tester.widget<MultipleShutterButton>(
          find.byType(MultipleShutterButton),
        );

        await multipleShutterButton.onShutter();
        await tester.pumpAndSettle();
        verify(
          () => multipleCaptureBloc.add(
            MultipleCaptureOnPhotoTaken(
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
    MultipleCaptureView subject,
    MultipleCaptureBloc multipleCaptureBloc,
  ) =>
      pumpApp(
        BlocProvider.value(
          value: multipleCaptureBloc,
          child: subject,
        ),
      );
}
