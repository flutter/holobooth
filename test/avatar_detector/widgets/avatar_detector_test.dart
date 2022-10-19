import 'dart:async';
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
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
  @override
  Future<void> startImageStream(onLatestImageAvailable onAvailable) async {
    onAvailable(_FakeCameraImage());
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

class _FakeCameraImageData extends Fake implements CameraImageData {}

class _MockCameraPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CameraPlatform {}

class _MockCameraImageData extends Mock implements CameraImageData {}

void main() {
  group('AvatarDetector', () {
    late AvatarDetectorBloc avatarDetectorBloc;
    late CameraController cameraController;

    setUp(() {
      avatarDetectorBloc = _MockAvatarDetectorBloc();
      when(() => avatarDetectorBloc.state).thenReturn(AvatarDetectorInitial());
      cameraController = _MockCameraController();
      registerFallbackValue(0);
    });

    testWidgets(
      'adds AvatarDetectorEstimateRequested when AvatarDetectorLoaded',
      (WidgetTester tester) async {
        final cameraPlatform = _MockCameraPlatform();
        CameraPlatform.instance = cameraPlatform;
        final frameStreamController = StreamController<CameraImageData>();
        final frameStream = frameStreamController.stream;
        when(() => cameraPlatform.onStreamedFrameAvailable(any()))
            .thenAnswer((_) => frameStream);

        whenListen(
          avatarDetectorBloc,
          Stream.value(AvatarDetectorLoaded()),
        );

        await tester.pumpSubject(
          AvatarDetector(cameraController: cameraController, child: SizedBox()),
          avatarDetectorBloc,
        );

        final cameraImageData = _MockCameraImageData();
        when(() => cameraImageData.height).thenReturn(10);
        when(() => cameraImageData.width).thenReturn(10);
        when(() => cameraImageData.planes.first.bytes).thenReturn(Uint8List(0));
        frameStreamController.add(cameraImageData);

        // expect event
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    AvatarDetector subject,
    AvatarDetectorBloc avatarDetectorBloc,
  ) =>
      pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: avatarDetectorBloc),
          ],
          child: subject,
        ),
      );
}
