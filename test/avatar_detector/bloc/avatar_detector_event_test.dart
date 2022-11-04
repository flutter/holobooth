import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';

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

void main() {
  group('AvatarDetectorEvent', () {
    group('AvatarDetectorInitialized', () {
      test('supports value comparison', () {
        expect(AvatarDetectorInitialized(), AvatarDetectorInitialized());
      });
    });

    group('AvatarDetectorEstimateRequested', () {
      test('supports value comparison', () {
        final cameraImage1 = _FakeCameraImage();
        final cameraImage2 = _FakeCameraImage();
        expect(
          AvatarDetectorEstimateRequested(cameraImage1),
          equals(AvatarDetectorEstimateRequested(cameraImage1)),
        );
        expect(
          AvatarDetectorEstimateRequested(cameraImage1),
          isNot(AvatarDetectorEstimateRequested(cameraImage2)),
        );
      });
    });
  });
}
