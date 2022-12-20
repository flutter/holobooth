import 'dart:collection';

import 'package:face_geometry/face_geometry.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;
import 'package:test/test.dart';

void main() {
  group('NormalizeNum', () {
    group('normalize', () {
      test('to greater values', () {
        expect(0.5.normalize(fromMax: 1, toMax: 3), equals(1.5));
        expect(0.5.normalize(fromMax: 2, toMax: 3), equals(0.75));
        expect(0.5.normalize(fromMax: 2, toMax: 4), equals(1));
      });

      test('to lower values', () {
        expect(0.5.normalize(fromMax: 4, toMax: 1), equals(0.125));
        expect(0.5.normalize(fromMax: 3, toMax: 2), equals(1 / 3));
        expect(0.5.normalize(fromMax: 4, toMax: 2), equals(0.25));
      });
    });
  });

  group('NormalizeKeypoint', () {
    group('normalize', () {
      const keypoint = tf.Keypoint(10, 10, null, 0, null);

      test('to greater value', () {
        expect(
          keypoint.normalize(
            fromMax: tf.Size(20, 30),
            toMax: tf.Size(40, 60),
          ),
          isA<tf.Keypoint>()
              .having((keypoint) => keypoint.x, 'x', 20)
              .having((keypoint) => keypoint.y, 'y', 20),
        );
      });

      test('to lower value', () {
        expect(
          keypoint.normalize(
            fromMax: tf.Size(40, 60),
            toMax: tf.Size(20, 30),
          ),
          isA<tf.Keypoint>()
              .having((keypoint) => keypoint.x, 'x', 5)
              .having((keypoint) => keypoint.y, 'y', 5),
        );
      });
    });
  });

  group('NormalizeBoundingBox', () {
    group('normalize', () {
      const boundingBox = tf.BoundingBox(10, 10, 30, 30, 20, 20);

      test('to greater value', () {
        expect(
          boundingBox.normalize(
            fromMax: tf.Size(20, 30),
            toMax: tf.Size(40, 60),
          ),
          isA<tf.BoundingBox>()
              .having((boundingBox) => boundingBox.height, 'width', 40)
              .having((boundingBox) => boundingBox.width, 'height', 40)
              .having((boundingBox) => boundingBox.xMax, 'xMax', 60)
              .having((boundingBox) => boundingBox.xMin, 'xMin', 20)
              .having((boundingBox) => boundingBox.yMax, 'yMax', 60)
              .having((boundingBox) => boundingBox.yMin, 'yMin', 20),
        );
      });

      test('to lower value', () {
        expect(
          boundingBox.normalize(
            fromMax: tf.Size(40, 60),
            toMax: tf.Size(20, 30),
          ),
          isA<tf.BoundingBox>()
              .having((boundingBox) => boundingBox.height, 'width', 10)
              .having((boundingBox) => boundingBox.width, 'height', 10)
              .having((boundingBox) => boundingBox.xMax, 'xMax', 15)
              .having((boundingBox) => boundingBox.xMin, 'xMin', 5)
              .having((boundingBox) => boundingBox.yMax, 'yMax', 15)
              .having((boundingBox) => boundingBox.yMin, 'yMin', 5),
        );
      });
    });
  });

  group('FaceNormalization', () {
    group('normalize', () {
      late tf.Face face;

      setUp(() {
        const keypoint = tf.Keypoint(10, 10, null, 0, null);
        const boundingBox = tf.BoundingBox(10, 10, 30, 30, 20, 20);
        face = tf.Face(
          UnmodifiableListView([keypoint]),
          boundingBox,
        );
      });

      test('to greater value', () {
        final normalizedFace = face.normalize(
          fromMax: tf.Size(20, 30),
          toMax: tf.Size(40, 60),
        );

        expect(normalizedFace.keypoints.first.x, 20);
        expect(normalizedFace.keypoints.first.y, 20);
        expect(normalizedFace.boundingBox.xMin, 20);
        expect(normalizedFace.boundingBox.yMin, 20);
        expect(normalizedFace.boundingBox.xMax, 60);
        expect(normalizedFace.boundingBox.yMax, 60);
        expect(normalizedFace.boundingBox.width, 40);
        expect(normalizedFace.boundingBox.height, 40);
      });

      test('to lower value', () {
        final normalizedFace = face.normalize(
          fromMax: tf.Size(40, 60),
          toMax: tf.Size(20, 30),
        );

        expect(normalizedFace.keypoints.first.x, 5);
        expect(normalizedFace.keypoints.first.y, 5);
        expect(normalizedFace.boundingBox.xMin, 5);
        expect(normalizedFace.boundingBox.yMin, 5);
        expect(normalizedFace.boundingBox.xMax, 15);
        expect(normalizedFace.boundingBox.yMax, 15);
        expect(normalizedFace.boundingBox.width, 10);
        expect(normalizedFace.boundingBox.height, 10);
      });
    });
  });

  group('FacesNormalization', () {
    group('normalize', () {
      late List<tf.Face> faces;

      setUp(() {
        const keypoint = tf.Keypoint(10, 10, null, 0, null);
        const boundingBox = tf.BoundingBox(10, 10, 30, 30, 20, 20);
        final face = tf.Face(
          UnmodifiableListView([keypoint]),
          boundingBox,
        );
        faces = [face];
      });

      test('to greater value', () {
        final normalizedFaces = faces.normalize(
          fromMax: tf.Size(20, 30),
          toMax: tf.Size(40, 60),
        );
        final normalizedFace = normalizedFaces.first;

        expect(normalizedFace.keypoints.first.x, 20);
        expect(normalizedFace.keypoints.first.y, 20);
        expect(normalizedFace.boundingBox.xMin, 20);
        expect(normalizedFace.boundingBox.yMin, 20);
        expect(normalizedFace.boundingBox.xMax, 60);
        expect(normalizedFace.boundingBox.yMax, 60);
        expect(normalizedFace.boundingBox.width, 40);
        expect(normalizedFace.boundingBox.height, 40);
      });

      test('to lower value', () {
        final normalizedFaces = faces.normalize(
          fromMax: tf.Size(40, 60),
          toMax: tf.Size(20, 30),
        );
        final normalizedFace = normalizedFaces.first;

        expect(normalizedFace.keypoints.first.x, 5);
        expect(normalizedFace.keypoints.first.y, 5);
        expect(normalizedFace.boundingBox.xMin, 5);
        expect(normalizedFace.boundingBox.yMin, 5);
        expect(normalizedFace.boundingBox.xMax, 15);
        expect(normalizedFace.boundingBox.yMax, 15);
        expect(normalizedFace.boundingBox.width, 10);
        expect(normalizedFace.boundingBox.height, 10);
      });
    });
  });
}
