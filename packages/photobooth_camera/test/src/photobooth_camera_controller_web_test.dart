// ignore: avoid_web_libraries_in_flutter
@TestOn('browser')
import 'dart:html' as html;

import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_camera/photobooth_camera.dart';
import 'package:photobooth_camera/src/photobooth_camera_controller_web.dart'
    show DomException;

class _MockCameraDescription extends Mock implements CameraDescription {}

void main() {
  group('PhotoboothCameraController', () {
    late CameraDescription cameraDescription;

    setUp(() {
      cameraDescription = _MockCameraDescription();
    });

    group('videoElement', () {
      test('returns a VideoElement when there is one', () {
        final videoElement = html.VideoElement();
        html.document.body!.append(videoElement);

        final cameraController = CameraController(
          cameraDescription,
          ResolutionPreset.max,
        );

        expect(cameraController.videoElement, equals(videoElement));
        videoElement.remove();
      });

      test('throws a DomException when there is no VideoElement', () {
        final cameraController = CameraController(
          cameraDescription,
          ResolutionPreset.max,
        );

        expect(
          () => cameraController.videoElement,
          throwsA(isA<DomException>()),
        );
      });
    });
  });
}
