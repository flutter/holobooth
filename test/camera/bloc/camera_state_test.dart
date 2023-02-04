import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/camera/camera.dart';

void main() {
  group('CameraState', () {
    final cameras = [
      CameraDescription(
        name: '1',
        lensDirection: CameraLensDirection.front,
        sensorOrientation: 0,
      ),
      CameraDescription(
        name: '2',
        lensDirection: CameraLensDirection.front,
        sensorOrientation: 0,
      ),
    ];
    final a = CameraState(availableCameras: cameras, camera: cameras[0]);
    final b = CameraState(availableCameras: cameras, camera: cameras[0]);

    test('uses value equality', () {
      expect(a, equals(b));
    });

    test('copyWith creates new instance', () {
      final c = a.copyWith();

      expect(a, isNot(same(c)));
    });
  });
}
