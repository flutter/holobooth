import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/camera/camera.dart';

void main() {
  group('CameraBloc', () {
    test('initial camera is null', () {
      expect(CameraState().camera, isNull);
    });

    final cameraDesc = CameraDescription(
      name: 'New camera',
      lensDirection: CameraLensDirection.front,
      sensorOrientation: 0,
    );

    blocTest<CameraBloc, CameraState>(
      'emits state with new camera when camera is changed',
      build: CameraBloc.new,
      act: (bloc) => bloc.add(CameraChanged(cameraDesc)),
      expect: () => [CameraState(camera: cameraDesc)],
    );
  });
}
