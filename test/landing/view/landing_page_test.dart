// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/landing/landing.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../helpers/helpers.dart';

class _FakeCameraOptions extends Fake implements CameraOptions {}

class _MockCameraPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CameraPlatform {}

class _MockCameraImage extends Mock implements CameraImage {}

void main() {
  const cameraId = 1;
  late CameraPlatform cameraPlatform;
  late CameraImage cameraImage;

  setUpAll(() {
    registerFallbackValue(_FakeCameraOptions());
  });

  setUp(() {
    cameraImage = _MockCameraImage();
    cameraPlatform = _MockCameraPlatform();
    CameraPlatform.instance = cameraPlatform;
    when(() => cameraImage.width).thenReturn(4);
    when(() => cameraImage.height).thenReturn(3);
    when(() => cameraPlatform.init()).thenAnswer((_) async => <void>{});
    when(
      () => cameraPlatform.create(any()),
    ).thenAnswer((_) async => cameraId);
    when(() => cameraPlatform.play(any())).thenAnswer((_) async => <void>{});
    when(() => cameraPlatform.stop(any())).thenAnswer((_) async => <void>{});
    when(() => cameraPlatform.dispose(any())).thenAnswer((_) async => <void>{});
    when(() => cameraPlatform.takePicture(any()))
        .thenAnswer((_) async => cameraImage);
    when(() => cameraPlatform.buildView(cameraId)).thenReturn(SizedBox());
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

    testWidgets('tapping on take photo button navigates to PhotoboothPage',
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

      expect(find.byType(PhotoboothPage), findsOneWidget);
      expect(find.byType(LandingView), findsNothing);
    });
  });
}
