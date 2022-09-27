// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockCameraPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CameraPlatform {}

class _MockCameraDescription extends Mock implements CameraDescription {}

class _MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

class _MockXFile extends Mock implements XFile {}

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

  group('PhotoboothPage', () {
    test('is routable', () {
      expect(PhotoboothPage.route(), isA<MaterialPageRoute<void>>());
    });

    testWidgets('displays a PhotoboothView', (tester) async {
      await tester.pumpApp(PhotoboothPage());
      await tester.pumpAndSettle();
      expect(find.byType(PhotoboothView), findsOneWidget);
    });
  });

  group('PhotoboothView', () {
    late PhotoboothBloc photoboothBloc;

    setUp(() {
      photoboothBloc = _MockPhotoboothBloc();
      when(() => photoboothBloc.state).thenReturn(PhotoboothState());
    });

    group('renders', () {
      testWidgets('PhotoboothView', (tester) async {
        final subject = PhotoboothView();
        await tester.pumpApp(subject, photoboothBloc: photoboothBloc);
        expect(find.byWidget(subject), findsOneWidget);
      });

      testWidgets('PhotoboothPreview', (tester) async {
        await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
        await tester.pump(Duration.zero);
        expect(find.byType(PhotoboothPreview), findsOneWidget);
      });

      testWidgets('placeholder when initializing', (tester) async {
        await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets('error when unavailable', (tester) async {
        when(() => cameraPlatform.availableCameras()).thenThrow(
          CameraException('', ''),
        );
        await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
        await tester.pumpAndSettle();
        expect(find.byType(PhotoboothError), findsOneWidget);
      });

      testWidgets(
          'camera access denied error '
          'when cameraPlatform throws CameraException '
          'with code "CameraAccessDenied"', (tester) async {
        when(() => cameraPlatform.availableCameras()).thenThrow(
          CameraException('CameraAccessDenied', ''),
        );
        await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
        await tester.pumpAndSettle();
        expect(
          find.byKey(Key('photoboothError_cameraAccessDenied')),
          findsOneWidget,
        );
      });

      testWidgets(
        'camera not found error '
        'when cameraPlatform throws CameraException '
        'with code "cameraNotFound"',
        (tester) async {
          when(() => cameraPlatform.availableCameras()).thenThrow(
            CameraException('cameraNotFound', ''),
          );
          await tester.pumpApp(
            PhotoboothView(),
            photoboothBloc: photoboothBloc,
          );
          await tester.pumpAndSettle();
          expect(
            find.byKey(Key('photoboothError_cameraNotFound')),
            findsOneWidget,
          );
        },
      );

      testWidgets(
          'camera not supported error '
          'when cameraPlatform throws CameraException '
          'with code "cameraNotSupported"', (tester) async {
        when(() => cameraPlatform.availableCameras()).thenThrow(
          CameraException('cameraNotSupported', ''),
        );
        await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
        await tester.pumpAndSettle();
        expect(
          find.byKey(Key('photoboothError_cameraNotSupported')),
          findsOneWidget,
        );
      });

      testWidgets(
          'unknown error '
          'when cameraPlatform throws CameraException '
          'with unknown code', (tester) async {
        when(() => cameraPlatform.availableCameras()).thenThrow(
          CameraException('', ''),
        );
        await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
        await tester.pumpAndSettle();
        expect(
          find.byKey(Key('photoboothError_unknown')),
          findsOneWidget,
        );
      });

      testWidgets('preview when available', (tester) async {
        const key = Key('__target__');
        const preview = SizedBox(key: key);
        when(() => cameraPlatform.buildPreview(cameraId)).thenReturn(preview);

        await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
        await tester.pumpAndSettle();

        expect(find.byType(PhotoboothPreview), findsOneWidget);
        expect(find.byKey(key), findsOneWidget);
      });

      testWidgets('landscape camera when orientation is landscape',
          (tester) async {
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.large, 400));
        await tester.pumpApp(PhotoboothPage());
        await tester.pumpAndSettle();

        final aspectRatio =
            tester.widget<AspectRatio>(find.byType(AspectRatio));
        expect(
          aspectRatio.aspectRatio,
          equals(PhotoboothAspectRatio.landscape),
        );
      });

      testWidgets(
        'portrait camera when orientation is portrait',
        (tester) async {
          tester.setDisplaySize(const Size(PhotoboothBreakpoints.small, 1000));
          await tester.pumpApp(PhotoboothPage());
          await tester.pumpAndSettle();

          final aspectRatio =
              tester.widget<AspectRatio>(find.byType(AspectRatio));
          expect(
            aspectRatio.aspectRatio,
            equals(PhotoboothAspectRatio.portrait),
          );
        },
      );
    });

    group('onSnapPressed', () {
      testWidgets(
          'adds PhotoCaptured with landscape aspect ratio '
          'when photo is snapped', (tester) async {
        await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
        await tester.pumpAndSettle();

        final photoboothPreview = tester.widget<PhotoboothPreview>(
          find.byType(PhotoboothPreview),
        );
        photoboothPreview.onSnapPressed();

        await tester.pumpAndSettle();

        verify(
          () => photoboothBloc.add(
            PhotoCaptured(
              aspectRatio: PhotoboothAspectRatio.landscape,
              image: image,
            ),
          ),
        ).called(1);
      });

      testWidgets(
          'adds PhotoCaptured with portrait aspect ratio '
          'when photo is snapped', (tester) async {
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.small, 1000));
        await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
        await tester.pumpAndSettle();

        final photoboothPreview = tester.widget<PhotoboothPreview>(
          find.byType(PhotoboothPreview),
        );

        photoboothPreview.onSnapPressed();

        await tester.pumpAndSettle();
        verify(
          () => photoboothBloc.add(
            PhotoCaptured(
              aspectRatio: PhotoboothAspectRatio.portrait,
              image: image,
            ),
          ),
        ).called(1);
      });

      testWidgets('navigates to StickersPage when photo is taken',
          (tester) async {
        await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
        await tester.pumpAndSettle();

        final photoboothPreview = tester.widget<PhotoboothPreview>(
          find.byType(PhotoboothPreview),
        );

        photoboothPreview.onSnapPressed();

        await tester.pumpAndSettle();

        expect(find.byType(StickersPage), findsOneWidget);
      });
    });
  });
}
