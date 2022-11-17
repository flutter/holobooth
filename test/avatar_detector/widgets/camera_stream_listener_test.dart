import 'dart:async';
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockAvatarDetectorBloc
    extends MockBloc<AvatarDetectorEvent, AvatarDetectorState>
    implements AvatarDetectorBloc {}

class _MockCameraController extends Mock implements CameraController {
  _MockCameraController(this.cameraImage);
  final CameraImage cameraImage;
  @override
  Future<void> startImageStream(onLatestImageAvailable onAvailable) async {
    onAvailable(cameraImage);
  }
}

class _FakePlane extends Fake implements Plane {
  @override
  Uint8List get bytes => Uint8List.fromList(List.empty());
}

class _FakeCameraImage extends Fake implements CameraImage {
  @override
  List<Plane> get planes => [_FakePlane()];

  @override
  int get width => 0;

  @override
  int get height => 0;
}

class _MockCameraPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CameraPlatform {}

class _FakeCameraImageData extends Fake implements CameraImageData {}

void main() {
  group('CameraStreamListener', () {
    late CameraController cameraController;
    late CameraImage cameraImage;
    late AvatarDetectorBloc avatarDetectorBloc;

    setUp(() {
      cameraImage = _FakeCameraImage();
      cameraController = _MockCameraController(cameraImage);
      avatarDetectorBloc = _MockAvatarDetectorBloc();
      when(() => avatarDetectorBloc.state).thenReturn(AvatarDetectorState());
    });

    testWidgets('adds AvatarDetectorEstimateRequested on every new frame',
        (tester) async {
      final cameraPlatform = _MockCameraPlatform();
      CameraPlatform.instance = cameraPlatform;
      final frameStreamController = StreamController<CameraImageData>();
      final frameStream = frameStreamController.stream;
      when(() => cameraPlatform.onStreamedFrameAvailable(any()))
          .thenAnswer((_) => frameStream);

      await tester.pumpSubject(
        CameraStreamListener(cameraController: cameraController),
        avatarDetectorBloc,
      );

      frameStreamController.add(_FakeCameraImageData());
      verify(
        () => avatarDetectorBloc
            .add(AvatarDetectorEstimateRequested(cameraImage)),
      ).called(1);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    CameraStreamListener subject,
    AvatarDetectorBloc avatarDetectorBloc,
  ) =>
      pumpApp(
        BlocProvider.value(
          value: avatarDetectorBloc,
          child: subject,
        ),
      );
}
