// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/backround_selection/view/background_selection.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/landing/landing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockCameraPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CameraPlatform {}

class _MockCameraDescription extends Mock implements CameraDescription {}

class _MockXFile extends Mock implements XFile {}

void main() {
  void setUpPhotoboothPage() {
    const cameraId = 1;
    final xfile = _MockXFile();
    when(() => xfile.path).thenReturn('');

    final cameraPlatform = _MockCameraPlatform();
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
  }

  setUp(setUpPhotoboothPage);

  tearDown(() {
    CameraPlatform.instance = _MockCameraPlatform();
  });

  group('LandingPage', () {
    testWidgets('renders landing view', (tester) async {
      await tester.pumpApp(const LandingPage());
      expect(find.byType(LandingView), findsOneWidget);
    });
  });

  group('LandingView', () {
    testWidgets('renders background', (tester) async {
      await tester.pumpApp(const LandingView());
      expect(find.byKey(Key('landingPage_background')), findsOneWidget);
    });

    testWidgets('renders heading', (tester) async {
      await tester.pumpApp(const LandingView());
      expect(find.byKey(Key('landingPage_heading_text')), findsOneWidget);
    });

    testWidgets('renders image', (tester) async {
      await tester.pumpApp(const LandingView());
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders image on small screens', (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.small, 1000));
      await tester.pumpApp(const LandingView());
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders subheading', (tester) async {
      await tester.pumpApp(const LandingView());
      expect(find.byKey(Key('landingPage_subheading_text')), findsOneWidget);
    });

    testWidgets('renders take photo button', (tester) async {
      await tester.pumpApp(const LandingView());
      expect(find.byType(LandingTakePhotoButton), findsOneWidget);
    });

    testWidgets('renders black footer', (tester) async {
      await tester.pumpApp(const LandingView());
      await tester.ensureVisible(find.byType(BlackFooter, skipOffstage: false));
      await tester.pumpAndSettle();
      expect(find.byType(BlackFooter), findsOneWidget);
    });

    testWidgets(
        'tapping on take photo button navigates to Background Selection Page',
        (tester) async {
      await runZonedGuarded(
        () async {
          await tester.pumpApp(const LandingView());
          await tester.ensureVisible(
            find.byType(
              LandingTakePhotoButton,
              skipOffstage: false,
            ),
          );
          await tester.pumpAndSettle();
          await tester.tap(
            find.byType(
              LandingTakePhotoButton,
              skipOffstage: false,
            ),
          );
          await tester.pumpAndSettle();
        },
        (_, __) {},
      );

      expect(find.byType(BackgroundSelectionPage), findsOneWidget);
      expect(find.byType(LandingView), findsNothing);
    });
  });
}
