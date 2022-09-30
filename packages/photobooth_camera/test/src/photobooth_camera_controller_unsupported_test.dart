@TestOn('!browser')

import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_camera/photobooth_camera.dart';

class _MockCameraDescription extends Mock implements CameraDescription {}

void main() {
  group('PhotoboothCameraController', () {
    late CameraDescription cameraDescription;

    setUp(() {
      cameraDescription = _MockCameraDescription();
    });

    group('videoElement', () {
      test('returns a VideoElement when there is one', () {
        final cameraController = CameraController(
          cameraDescription,
          ResolutionPreset.max,
        );
        expect(() => cameraController.videoElement, throwsUnsupportedError);
      });
    });
  });
}
