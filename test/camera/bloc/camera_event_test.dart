import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/camera/camera.dart';

void main() {
  group('CameraEvent', () {
    group('CameraStarted', () {
      test('uses value equality', () {
        final a = CameraStarted();
        final b = CameraStarted();

        expect(a, equals(b));
      });
    });

    group('CameraChanged', () {
      test('uses value equality', () {
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
        final a = CameraChanged(cameras[0]);
        final b = CameraChanged(cameras[0]);
        final c = CameraChanged(cameras[1]);

        expect(a, equals(b));
        expect(a, isNot(c));
      });
    });
  });
}
