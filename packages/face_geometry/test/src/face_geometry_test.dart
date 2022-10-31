import 'dart:collection';

import 'package:face_geometry/face_geometry.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;
import 'package:test/test.dart';

class _MockKeypoint extends Mock implements tf.Keypoint {}

class _MockBoundingBox extends Mock implements tf.BoundingBox {}

void main() {
  setUpAll(() {
    registerFallbackValue(tf.Size(0, 0));
  });

  group('FaceGeometry', () {
    group('contains geometry for', () {
      test('direction', () {
        final faceGeometry = FaceGeometry(const [], _MockBoundingBox());

        expect(faceGeometry.direction, isA<FaceDirection>());
      });

      test('leftEye', () {
        final faceGeometry = FaceGeometry(const [], _MockBoundingBox());

        expect(faceGeometry.leftEye, isA<EyeGeometry>());
      });

      test('rightEye', () {
        final faceGeometry = FaceGeometry(const [], _MockBoundingBox());

        expect(faceGeometry.rightEye, isA<EyeGeometry>());
      });

      test('mouth', () {
        final faceGeometry = FaceGeometry(const [], _MockBoundingBox());

        expect(faceGeometry.mouth, isA<MouthGeometry>());
      });
    });

    test('update changes FaceGeometry', () {
      final newKeypoints = UnmodifiableListView(<tf.Keypoint>[_MockKeypoint()]);
      final faceGeometry = FaceGeometry(const [], _MockBoundingBox());
      final faceGeometry2 = FaceGeometry(const [], _MockBoundingBox());

      faceGeometry.update(newKeypoints, _MockBoundingBox());

      expect(faceGeometry.keypoints, equals(newKeypoints));
      expect(faceGeometry, isNot(faceGeometry2));
    });
  });
}
