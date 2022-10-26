import 'dart:collection';

import 'package:face_geometry/face_geometry.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:test/test.dart';

class _MockFace extends Mock implements tf.Face {}

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

        expect(faceGeometry.mouth, isA<FaceDirection>());
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
        final keypoint = tf.Keypoint.fromJson({'x': 10, 'y': 10});

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
        final boundingBox = tf.BoundingBox.fromJson({
          'xMin': 10,
          'yMin': 10,
          'xMax': 30,
          'yMax': 30,
          'width': 20,
          'height': 20,
        });

        test('to greater value', () {
          expect(
            boundingBox.normalize(
              fromMax: Size(20, 30),
              toMax: Size(40, 60),
            ),
            isA<tf.BoundingBox>()
                .having((keypoint) => keypoint.height, 'width', 40)
                .having((keypoint) => keypoint.width, 'height', 40)
                .having((keypoint) => keypoint.xMax, 'xMax', 60)
                .having((keypoint) => keypoint.xMin, 'xMin', 20)
                .having((keypoint) => keypoint.yMax, 'yMax', 60)
                .having((keypoint) => keypoint.yMin, 'yMin', 20),
          );
        });
        test('to lower value', () {
          expect(
            boundingBox.normalize(
              fromMax: Size(40, 60),
              toMax: Size(20, 30),
            ),
            isA<tf.BoundingBox>()
                .having((keypoint) => keypoint.height, 'width', 10)
                .having((keypoint) => keypoint.width, 'height', 10)
                .having((keypoint) => keypoint.xMax, 'xMax', 15)
                .having((keypoint) => keypoint.xMin, 'xMin', 5)
                .having((keypoint) => keypoint.yMax, 'yMax', 15)
                .having((keypoint) => keypoint.yMin, 'yMin', 5),
          );
        });
      });

      group('calls normalize on', () {
        late tf.Face face;
        late tf.Keypoint keypoint;
        late tf.BoundingBox boundingBox;

        setUp(() {
          face = _MockFace();
          keypoint = _MockKeypoint();
          boundingBox = _MockBoundingBox();

          when(() => face.keypoints).thenReturn(
            UnmodifiableListView([keypoint, keypoint]),
          );
          when(() => face.boundingBox).thenReturn(boundingBox);
          when(() => keypoint.x).thenReturn(0);
          when(() => keypoint.y).thenReturn(0);
          when(
            () => keypoint.copyWith(
              x: any(named: 'x'),
              y: any(named: 'y'),
            ),
          ).thenReturn(keypoint);
          when(() => boundingBox.xMin).thenReturn(0);
          when(() => boundingBox.yMin).thenReturn(0);
          when(() => boundingBox.xMax).thenReturn(0);
          when(() => boundingBox.yMax).thenReturn(0);
          when(() => boundingBox.width).thenReturn(0);
          when(() => boundingBox.height).thenReturn(0);
          when(
            () => boundingBox.copyWith(
              xMin: any(named: 'xMin'),
              yMin: any(named: 'yMin'),
              xMax: any(named: 'xMax'),
              yMax: any(named: 'yMax'),
              width: any(named: 'width'),
              height: any(named: 'height'),
            ),
          ).thenReturn(boundingBox);

          when(
            () => face.copyWith(
              boundingBox: any(named: 'boundingBox'),
              keypoints: any(named: 'keypoints'),
            ),
          ).thenReturn(face);
        });

        test('Face.BoundingBox', () {
          face.normalize(
            fromMax: Size(20, 30),
            toMax: Size(40, 60),
          );

          verify(
            () => boundingBox.normalize(
              fromMax: Size(20, 30),
              toMax: Size(40, 60),
            ),
          ).called(1);
        });

        test('Face.keypoints', () {
          face.normalize(
            fromMax: Size(20, 30),
            toMax: Size(40, 60),
          );

          verify(
            () => keypoint.normalize(
              fromMax: Size(20, 30),
              toMax: Size(40, 60),
            ),
          ).called(2);
        });
      });
    });
  });
}
