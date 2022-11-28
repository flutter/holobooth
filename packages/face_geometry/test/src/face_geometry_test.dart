import 'dart:collection';

import 'package:face_geometry/face_geometry.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;
import 'package:test/test.dart';

class _MockBoundingBox extends Mock implements tf.BoundingBox {}

class _MockFace extends Mock implements tf.Face {}

class _FakeKeypoint extends Fake implements tf.Keypoint {
  _FakeKeypoint(this.x, this.y, this.z);

  @override
  final num x;

  @override
  final num y;

  @override
  final num z;
}

void main() {
  setUpAll(() {
    registerFallbackValue(tf.Size(0, 0));
  });

  group('FaceGeometry', () {
    late tf.Face face;
    late tf.Size size;
    late tf.BoundingBox boundingBox;

    setUp(() {
      boundingBox = _MockBoundingBox();
      when(() => boundingBox.height).thenReturn(0);
      when(() => boundingBox.width).thenReturn(0);

      face = _MockFace();
      when(() => face.boundingBox).thenReturn(boundingBox);

      size = tf.Size(1, 1);
    });

    group('constructor', () {
      test('returns normally when no keypoints are given', () {
        when(() => face.keypoints).thenReturn(UnmodifiableListView([]));

        expect(
          () => FaceGeometry(face: face, size: size),
          returnsNormally,
        );
      });

      test('returns normally when keypoints are given', () {
        final keypoints = List.generate(468, (_) => _FakeKeypoint(0, 0, 0));
        when(() => face.keypoints).thenReturn(UnmodifiableListView(keypoints));

        expect(
          () => FaceGeometry(face: face, size: size),
          returnsNormally,
        );
      });
    });

    group('update', () {
      test('returns normally when keypoints are given', () {
        final keypoints = List.generate(468, (_) => _FakeKeypoint(0, 0, 0));
        when(() => face.keypoints).thenReturn(UnmodifiableListView(keypoints));
        final faceGeometry = FaceGeometry(face: face, size: size);

        expect(
          () => faceGeometry.update(face: face, size: size),
          returnsNormally,
        );
      });
    });

    test('supports value equality', () {
      when(() => face.keypoints).thenReturn(UnmodifiableListView([]));
      final faceGeometry1 = FaceGeometry(face: face, size: size);
      final faceGeometry2 = FaceGeometry(face: face, size: size);

      expect(faceGeometry1, equals(faceGeometry2));
    });
  });
}
