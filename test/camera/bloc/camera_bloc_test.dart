import 'package:bloc_test/bloc_test.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/camera/camera.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _MockCameraPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CameraPlatform {}

void main() {
  group('CameraBloc', () {
    late CameraPlatform cameraPlatform;
    const camerasStub = [
      CameraDescription(
        name: 'New camera 1',
        lensDirection: CameraLensDirection.front,
        sensorOrientation: 0,
      ),
      CameraDescription(
        name: 'New camera 2',
        lensDirection: CameraLensDirection.front,
        sensorOrientation: 0,
      ),
    ];
    final cameraException = CameraException('code', 'description');

    setUp(() {
      cameraPlatform = _MockCameraPlatform();
      CameraPlatform.instance = cameraPlatform;

      when(cameraPlatform.availableCameras)
          .thenAnswer((_) async => camerasStub);
    });

    tearDown(() {
      CameraPlatform.instance = _MockCameraPlatform();
    });

    test('initial camera is null', () {
      expect(CameraState().camera, isNull);
    });

    blocTest<CameraBloc, CameraState>(
      'emits state with available cameras and first camera selected '
      'when camera initialized',
      build: CameraBloc.new,
      act: (bloc) => bloc.add(CameraStarted()),
      expect: () =>
          [CameraState(availableCameras: camerasStub, camera: camerasStub[0])],
    );

    blocTest<CameraBloc, CameraState>(
      'emits state with error when error occurred during initialization',
      setUp: () =>
          when(cameraPlatform.availableCameras).thenThrow(cameraException),
      build: CameraBloc.new,
      act: (bloc) => bloc.add(CameraStarted()),
      expect: () => [CameraState(cameraError: cameraException)],
    );

    blocTest<CameraBloc, CameraState>(
      'emits nothing if camera is already initialized',
      build: CameraBloc.new,
      seed: () => CameraState(availableCameras: camerasStub),
      act: (bloc) => bloc.add(CameraStarted()),
      expect: () => <CameraState>[],
    );

    blocTest<CameraBloc, CameraState>(
      'emits state with new camera when camera is changed',
      build: CameraBloc.new,
      act: (bloc) => bloc.add(CameraChanged(camerasStub[0])),
      expect: () => [CameraState(camera: camerasStub[0])],
    );

    blocTest<CameraBloc, CameraState>(
      'emits nothing if changed camera is the same as before',
      build: CameraBloc.new,
      seed: () => CameraState(camera: camerasStub[0]),
      act: (bloc) => bloc.add(CameraChanged(camerasStub[0])),
      expect: () => <CameraState>[],
    );
  });
}
