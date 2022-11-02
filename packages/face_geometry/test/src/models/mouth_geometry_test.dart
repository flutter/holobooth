import 'dart:collection';

import 'package:face_geometry/face_geometry.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:test/test.dart';

import '../../fixtures/fixtures.dart' as fixtures;

const _keypointsInFace = 468;

class _MockBoundingBox extends Mock implements BoundingBox {}

class _FakeKeypoint extends Fake implements Keypoint {
  _FakeKeypoint(this.x, this.y);

  @override
  final double x;

  @override
  final double y;
}

void main() {
  late BoundingBox boundingBox;

  setUp(() {
    boundingBox = _MockBoundingBox();
    when(() => boundingBox.height).thenReturn(0);
  });

  group('MouthGeometry', () {
    group('factory constructor', () {
      test('returns normally when no keypoints are given', () {
        expect(
          () => MouthGeometry(
            keypoints: const [],
            boundingBox: boundingBox,
          ),
          returnsNormally,
        );
      });

      test('returns normally when keypoints are given', () {
        expect(
          () => MouthGeometry(
            keypoints: List.generate(
              _keypointsInFace,
              (_) => _FakeKeypoint(0, 0),
            ),
            boundingBox: boundingBox,
          ),
          returnsNormally,
        );
      });
    });

    group('isOpen', () {
      test('is false when no keypoints are given', () {
        final mouthGeometry = MouthGeometry(
          keypoints: const [],
          boundingBox: boundingBox,
        );

        expect(mouthGeometry.isOpen, isFalse);
      });

      test('is false with face1', () {
        final face = fixtures.face1;
        final mouthGeometry = MouthGeometry(
          keypoints: face.keypoints,
          boundingBox: face.boundingBox,
        );

        expect(mouthGeometry.isOpen, isFalse);
      });
    });
  });
}
