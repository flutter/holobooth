import 'package:bloc_test/bloc_test.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:io_photobooth/share/share.dart';
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

class _FakePhotoboothCameraImage extends Fake implements PhotoboothCameraImage {
  @override
  String get data => '';

  @override
  PhotoConstraint get constraint => PhotoConstraint();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
        await tester.pump();
        expect(find.byType(PhotoBoothView), findsOneWidget);
      },
    );
  });

  group('PhotoBoothView', () {
    late PhotoBoothBloc photoBoothBloc;
    late InExperienceSelectionBloc inExperienceSelectionBloc;
    late AvatarDetectorBloc avatarDetectorBloc;

    setUp(() {
      photoBoothBloc = _MockPhotoBoothBloc();
      when(
        () => photoBoothBloc.state,
      ).thenReturn(PhotoBoothState.empty());

      inExperienceSelectionBloc = _MockInExperienceSelectionBloc();
      when(() => inExperienceSelectionBloc.state)
          .thenReturn(InExperienceSelectionState());

      avatarDetectorBloc = _MockAvatarDetectorBloc();
      when(() => avatarDetectorBloc.state).thenReturn(
        AvatarDetectorState(status: AvatarDetectorStatus.loaded),
      );
    });

    setUpAll(() {
      registerFallbackValue(_FakePhotoboothCameraImage());
    });

    testWidgets(
      'navigates to SharePage when isFinished',
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
          inExperienceSelectionBloc: inExperienceSelectionBloc,
          avatarDetectorBloc: avatarDetectorBloc,
        );
        await tester.pumpAndSettle();
        expect(find.byType(SharePage), findsOneWidget);
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    PhotoBoothView subject, {
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
          child: subject,
        ),
      );
}
