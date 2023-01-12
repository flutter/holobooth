import 'dart:ui' as ui;

import 'package:bloc_test/bloc_test.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/audio_player/audio_player.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';
import 'package:io_photobooth/convert/convert.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:screen_recorder/screen_recorder.dart';

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

class _MockImage extends Mock implements ui.Image {}

class _MockAudioPlayer extends Mock implements AudioPlayer {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(LoopMode.all);
  });

  const cameraId = 1;
  late CameraPlatform cameraPlatform;
  late XFile xfile;
  late AudioPlayer audioPlayer;

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

    audioPlayer = _MockAudioPlayer();

    when(audioPlayer.pause).thenAnswer((_) async {});
    when(audioPlayer.play).thenAnswer((_) async {});
    when(audioPlayer.stop).thenAnswer((_) async {});
    when(audioPlayer.dispose).thenAnswer((_) async {});
    when(() => audioPlayer.setLoopMode(any())).thenAnswer((_) async {});
    when(() => audioPlayer.loopMode).thenReturn(LoopMode.off);
    when(() => audioPlayer.seek(any())).thenAnswer((_) async {});
    when(() => audioPlayer.setAsset(any()))
        .thenAnswer((_) async => Duration.zero);

    AudioPlayerMixin.audioPlayerOverride = audioPlayer;

    const MethodChannel('com.ryanheise.audio_session')
        .setMockMethodCallHandler((call) async {
      if (call.method == 'getConfiguration') {
        return {};
      }
    });
  });

  tearDown(() {
    CameraPlatform.instance = _MockCameraPlatform();

    AudioPlayerMixin.audioPlayerOverride = null;
  });

  group('PhotoBoothPage', () {
    test('is routable', () {
      expect(
        PhotoBoothPage.route(),
        isA<MaterialPageRoute<void>>(),
      );
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
      ).thenReturn(PhotoBoothState());

      inExperienceSelectionBloc = _MockInExperienceSelectionBloc();
      when(() => inExperienceSelectionBloc.state)
          .thenReturn(InExperienceSelectionState());

      avatarDetectorBloc = _MockAvatarDetectorBloc();
      when(() => avatarDetectorBloc.state).thenReturn(
        AvatarDetectorState(status: AvatarDetectorStatus.loaded),
      );
    });

    testWidgets('plays audio', (WidgetTester tester) async {
      await tester.pumpSubject(
        PhotoBoothView(),
        photoBoothBloc: photoBoothBloc,
        inExperienceSelectionBloc: inExperienceSelectionBloc,
        avatarDetectorBloc: avatarDetectorBloc,
      );

      await tester.pump();

      verify(() => audioPlayer.setAsset(Assets.audio.experienceAmbient))
          .called(1);
      verify(audioPlayer.play).called(1);
    });

    testWidgets(
      'navigates to ConvertPage when isFinished',
      (WidgetTester tester) async {
        whenListen(
          photoBoothBloc,
          Stream.value(
            PhotoBoothState(frames: [Frame(Duration.zero, _MockImage())]),
          ),
        );
        await tester.pumpSubject(
          PhotoBoothView(),
          photoBoothBloc: photoBoothBloc,
          inExperienceSelectionBloc: inExperienceSelectionBloc,
          avatarDetectorBloc: avatarDetectorBloc,
        );

        /// Wait for the player to complete
        await tester.pump(Duration(seconds: 3));
        await tester.pump(Duration(seconds: 2));
        expect(find.byType(ConvertPage), findsOneWidget);
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    Widget subject, {
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
