import 'dart:collection';

import 'package:face_geometry/face_geometry.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:test/test.dart';

class _MockKeypoint extends Mock implements tf.Keypoint {}

class _MockBoundingBox extends Mock implements tf.BoundingBox {}

void main() {
  setUpAll(() {
    registerFallbackValue(Size(0, 0));
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
      final newKeypoints = UnmodifiableListView(<Keypoint>[_MockKeypoint()]);
      final faceGeometry = FaceGeometry(const [], _MockBoundingBox());
      final faceGeometry2 = FaceGeometry(const [], _MockBoundingBox());

      faceGeometry.update(newKeypoints, _MockBoundingBox());

      expect(faceGeometry.keypoints, equals(newKeypoints));
      expect(faceGeometry, isNot(faceGeometry2));
    });

    group('normalize', () {
      final keypoint = tf.Keypoint.fromJson({'x': 10, 'y': 10});
      final boundingBox = tf.BoundingBox.fromJson({
        'xMin': 10,
        'yMin': 10,
        'xMax': 30,
        'yMax': 30,
        'width': 20,
        'height': 20,
      });

      group('the number', () {
        test('throws assertion when fromMax is equals 0', () {
          expect(
            () => 0.normalize(fromMax: 0, toMax: 1),
            throwsA(isA<AssertionError>()),
          );
        });

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

      group('the keypoint', () {
        test('to greater value', () {
          expect(
            keypoint.normalize(
              fromMax: Size(20, 30),
              toMax: Size(40, 60),
            ),
            isA<tf.Keypoint>()
                .having((keypoint) => keypoint.x, 'x', 20)
                .having((keypoint) => keypoint.y, 'y', 20),
          );
        });
        test('to lower value', () {
          expect(
            keypoint.normalize(
              fromMax: Size(40, 60),
              toMax: Size(20, 30),
            ),
            isA<tf.Keypoint>()
                .having((keypoint) => keypoint.x, 'x', 5)
                .having((keypoint) => keypoint.y, 'y', 5),
          );
        });
      });

      group('the BoundingBox', () {
        test('to greater value', () {
          expect(
            boundingBox.normalize(
              fromMax: Size(20, 30),
              toMax: Size(40, 60),
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
              fromMax: Size(40, 60),
              toMax: Size(20, 30),
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

      group('the Face', () {
        final face = tf.Face(
          UnmodifiableListView([keypoint]),
          boundingBox,
        );

        test('to greater value', () {
          final normalizedFace = face.normalize(
            fromMax: Size(20, 30),
            toMax: Size(40, 60),
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
            fromMax: Size(40, 60),
            toMax: Size(20, 30),
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
  });
}
