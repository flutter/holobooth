// ignore_for_file: prefer_const_constructors

import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/camera/camera.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockCameraPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CameraPlatform {}

class _MockCameraDescription extends Mock implements CameraDescription {}

void main() {
  group('CameraView', () {
    const cameraId = 1;
    late CameraPlatform cameraPlatform;

    setUp(() {
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
      when(cameraPlatform.availableCameras)
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
      when(() => cameraPlatform.buildPreview(cameraId)).thenReturn(SizedBox());
      when(() => cameraPlatform.dispose(any())).thenAnswer(
        (_) async => <void>{},
      );
    });

    tearDown(() {
      CameraPlatform.instance = _MockCameraPlatform();
    });

    testWidgets('calls onCameraReady when ready', (tester) async {
      var calls = 0;
      await tester.pumpSubject(CameraView(onCameraReady: (_) => calls++));
      await tester.pumpAndSettle();
      expect(calls, equals(1));
    });

    testWidgets('renders loadingKey when loading', (tester) async {
      await tester.pumpSubject(CameraView(onCameraReady: (_) {}));
      expect(find.byKey(CameraView.cameraLoadingKey), findsOneWidget);
    });

    testWidgets('cameraPreviewKey when loaded', (tester) async {
      await tester.pumpSubject(CameraView(onCameraReady: (_) {}));
      await tester.pumpAndSettle();
      expect(find.byKey(CameraView.cameraPreviewKey), findsOneWidget);
    });

    testWidgets('renders CameraErrorView when has a CameraExceptionerror',
        (tester) async {
      when(() => cameraPlatform.availableCameras()).thenThrow(
        CameraException('', ''),
      );
      await tester.pumpSubject(CameraView(onCameraReady: (_) {}));
      await tester.pumpAndSettle();

      expect(find.byType(CameraErrorView), findsOneWidget);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(CameraView subject) => pumpApp(subject);
}
