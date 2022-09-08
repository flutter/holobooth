// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../helpers/helpers.dart';

class _FakePhotoboothEvent extends Fake implements PhotoboothEvent {}

class _MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

class _MockPhotosRepository extends Mock implements PhotosRepository {}

class _MockCameraPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CameraPlatform {}

class _MockCameraImage extends Mock implements CameraImage {}

class _FakeCameraOptions extends Fake implements CameraOptions {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const width = 1;
  const height = 1;
  const data = '';
  const image = CameraImage(width: width, height: height, data: data);

  late PhotosRepository photosRepository;
  late PhotoboothBloc photoboothBloc;
  late ShareBloc shareBloc;

  setUpAll(() {
    registerFallbackValue(_FakePhotoboothEvent());
    registerFallbackValue(FakeShareEvent());
    registerFallbackValue(_FakeCameraOptions());
  });

  setUp(() {
    photosRepository = _MockPhotosRepository();
    when(
      () => photosRepository.composite(
        width: width,
        height: height,
        data: data,
        layers: [],
        aspectRatio: any(named: 'aspectRatio'),
      ),
    ).thenAnswer((_) async => Uint8List.fromList([]));
    photoboothBloc = _MockPhotoboothBloc();
    when(() => photoboothBloc.state).thenReturn(PhotoboothState(image: image));

    shareBloc = MockShareBloc();
    whenListen(
      shareBloc,
      Stream.fromIterable([ShareState()]),
      initialState: ShareState(),
    );
  });

  group('SharePage', () {
    test('is routable', () {
      expect(SharePage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders a ShareView', (tester) async {
      await tester.pumpApp(
        SharePage(),
        photosRepository: photosRepository,
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(find.byType(ShareView), findsOneWidget);
    });
  });

  group('ShareView', () {
    late CameraPlatform cameraPlatform;
    late CameraImage cameraImage;
    const cameraId = 1;

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
      when(() => cameraPlatform.dispose(any()))
          .thenAnswer((_) async => <void>{});
      when(() => cameraPlatform.takePicture(any()))
          .thenAnswer((_) async => cameraImage);
    });
    testWidgets('displays a ShareBackground', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(find.byType(ShareBackground), findsOneWidget);
    });

    testWidgets('displays a ShareBody', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(find.byType(ShareBody), findsOneWidget);
    });

    testWidgets('displays a WhiteFooter', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      await tester.ensureVisible(find.byType(WhiteFooter, skipOffstage: false));
    });

    testWidgets('displays a ShareRetakeButton', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(
        find.byKey(const Key('sharePage_retake_appTooltipButton')),
        findsOneWidget,
      );
    });

    testWidgets('displays a ShareProgressOverlay', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(find.byType(ShareProgressOverlay), findsOneWidget);
    });
  });
}
