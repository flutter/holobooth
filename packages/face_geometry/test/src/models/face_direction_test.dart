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

    group('detects that', () {
      test('face1 is looking straight', () {
        final face = fixtures.face1;
        final faceDirection = FaceDirection(keypoints: face.keypoints);

        expect(faceDirection.value.x, closeTo(0, 0.6));
        expect(faceDirection.value.y, closeTo(0, 0.6));
        expect(faceDirection.value.z, closeTo(0, 0.1));
      });

      test('face2 is looking straight', () {
        final face = fixtures.face2;
        final faceDirection = FaceDirection(keypoints: face.keypoints);

        expect(faceDirection.value.x, closeTo(0, 0.6));
        expect(faceDirection.value.y, closeTo(0, 0.6));
        expect(faceDirection.value.z, closeTo(0, 0.1));
      });

      test('face3 is looking straight', () {
        final face = fixtures.face3;
        final faceDirection = FaceDirection(keypoints: face.keypoints);

        expect(faceDirection.value.x, closeTo(0, 0.6));
        expect(faceDirection.value.y, closeTo(0, 0.6));
        expect(faceDirection.value.z, closeTo(0, 0.1));
      });

      test('face4 is looking straight', () {
        final face = fixtures.face4;
        final faceDirection = FaceDirection(keypoints: face.keypoints);

        expect(faceDirection.value.x, closeTo(0, 0.6));
        expect(faceDirection.value.y, closeTo(0, 0.6));
        expect(faceDirection.value.z, closeTo(0, 0.1));
      });

      test('face5 is looking straight', () {
        final face = fixtures.face5;
        final faceDirection = FaceDirection(keypoints: face.keypoints);

        expect(faceDirection.value.x, closeTo(0, 0.6));
        expect(faceDirection.value.y, closeTo(0, 0.6));
        expect(faceDirection.value.z, closeTo(0, 0.1));
      });

      test('face6 is looking up', () {
        final face = fixtures.face6;
        final faceDirection = FaceDirection(keypoints: face.keypoints);

        expect(faceDirection.value.x, closeTo(0, 0.6));
        expect(faceDirection.value.y, greaterThan(0.6));
        expect(faceDirection.value.z, closeTo(0, 0.1));
      });

      test('face7 is looking left', () {
        final face = fixtures.face7;
        final faceDirection = FaceDirection(keypoints: face.keypoints);

        expect(faceDirection.value.x, greaterThan(0.6));
        expect(faceDirection.value.y, closeTo(0, 0.6));
        expect(faceDirection.value.z, closeTo(0, 0.1));
      });

      test('face8 is looking right', () {
        final face = fixtures.face8;
        final faceDirection = FaceDirection(keypoints: face.keypoints);

        expect(faceDirection.value.x, lessThan(-0.6));
        expect(faceDirection.value.y, closeTo(0, 0.6));
        expect(faceDirection.value.z, closeTo(0, 0.1));
      });

      test('face9 is looking right up', () {
        final face = fixtures.face9;
        final faceDirection = FaceDirection(keypoints: face.keypoints);

        expect(faceDirection.value.x, lessThan(-0.6));
        expect(faceDirection.value.y, greaterThan(0.6));
        expect(faceDirection.value.z, greaterThan(0.3));
      });

      test('face10 is looking straight', () {
        final face = fixtures.face10;
        final faceDirection = FaceDirection(keypoints: face.keypoints);

        expect(faceDirection.value.x, closeTo(0, 0.6));
        expect(faceDirection.value.y, closeTo(0, 0.6));
        expect(faceDirection.value.z, closeTo(0, 0.1));
      });
    });
  });
}
