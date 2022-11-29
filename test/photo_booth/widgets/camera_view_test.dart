// ignore_for_file: prefer_const_constructors

import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

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

    test('can be instantiated', () {
      expect(
        CameraView(
          onCameraReady: (_) {},
          errorBuilder: (_, __) => const SizedBox(),
        ),
        isA<CameraView>(),
      );
    });

    testWidgets('called when ready', (tester) async {
      var calls = 0;
      final subject = CameraView(
        onCameraReady: (_) => calls++,
        errorBuilder: (_, __) => const SizedBox(),
      );
      await tester.pumpWidget(subject);
      await tester.pumpAndSettle();
      expect(calls, equals(1));
    });

    group('renders', () {
      testWidgets('loadingKey when loading', (tester) async {
        final subject = CameraView(
          onCameraReady: (_) {},
          errorBuilder: (_, __) => const SizedBox(),
        );
        await tester.pumpWidget(subject);

        expect(find.byKey(CameraView.loadingKey), findsOneWidget);
      });

      testWidgets('cameraPreviewKey when loaded', (tester) async {
        final subject = CameraView(
          onCameraReady: (_) {},
          errorBuilder: (_, __) => const SizedBox(),
        );
        await tester.pumpWidget(subject);
        await tester.pumpAndSettle();

        expect(find.byKey(CameraView.cameraPreviewKey), findsOneWidget);
      });

      testWidgets('errorBuilder when has an error', (tester) async {
        when(() => cameraPlatform.availableCameras()).thenThrow(
          CameraException('', ''),
        );
        const errorKey = Key('error');
        final subject = CameraView(
          onCameraReady: (_) {},
          errorBuilder: (_, __) => const SizedBox(key: errorKey),
        );
        await tester.pumpWidget(subject);
        await tester.pumpAndSettle();

        expect(find.byKey(errorKey), findsOneWidget);
      });
    });
  });
}
