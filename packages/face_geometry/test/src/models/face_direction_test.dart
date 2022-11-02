import 'package:face_geometry/face_geometry.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;
import 'package:test/test.dart';

import '../../fixtures/fixtures.dart' as fixtures;

class _FakeKeypoint extends Fake implements tf.Keypoint {
  _FakeKeypoint(this.x, this.y, this.z);

  @override
  final double x;

  @override
  final double y;

  @override
  final double? z;
}

void main() {
  group('FaceDirection', () {
    group('factory constructor', () {
      test('returns normally when no keypoints are given', () {
        expect(
          () => FaceDirection(
            keypoints: const [],
          ),
          returnsNormally,
        );
      });

      test('returns normally when keypoints are given', () {
        final keypoints = List.generate(468, (_) => _FakeKeypoint(0, 0, 0));
        expect(
          () => FaceDirection(
            keypoints: keypoints,
          ),
          returnsNormally,
        );
      });
    });

    group('value', () {
      test('is zero when no keypoints are given', () {
        final faceDirection = FaceDirection(
          keypoints: const [],
        );

        expect(faceDirection.value, equals(Vector3.zero));
      });
    });

    test('supports value equality', () {
      final faceDirection1 = FaceDirection(keypoints: const []);
      final faceDirection2 = FaceDirection(keypoints: const []);
      final faceDirection3 = FaceDirection(keypoints: fixtures.face1.keypoints);

      expect(faceDirection1, equals(faceDirection2));
      expect(faceDirection1, isNot(equals(faceDirection3)));
      expect(faceDirection2, isNot(equals(faceDirection3)));
    });
  });
}
