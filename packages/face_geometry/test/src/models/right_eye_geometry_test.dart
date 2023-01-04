import 'package:face_geometry/face_geometry.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:test/test.dart';

import '../../fixtures/fixtures.dart' as fixtures;

class _MockBoundingBox extends Mock implements BoundingBox {}

class _FakeKeypoint extends Fake implements Keypoint {
  _FakeKeypoint(this.x, this.y);

  @override
  final double x;

  @override
  final double y;
}

void main() {
  group('RightEyeGeometry', () {
    late BoundingBox boundingBox;

    setUp(() {
      boundingBox = _MockBoundingBox();
      when(() => boundingBox.height).thenReturn(0);
    });

    group('factory constructor', () {
      test('returns normally when no keypoints are given', () {
        expect(
          () => RightEyeGeometry(
            keypoints: const [],
            boundingBox: boundingBox,
          ),
          returnsNormally,
        );
      });

      test('returns normally when keypoints are given', () {
        final keypoints = List.generate(468, (_) => _FakeKeypoint(0, 0));
        expect(
          () => RightEyeGeometry(
            keypoints: keypoints,
            boundingBox: boundingBox,
          ),
          returnsNormally,
        );
      });
    });

    group('update', () {
      test('return normally when no keypoints are given', () {
        final geometry = RightEyeGeometry(
          keypoints: const [],
          boundingBox: boundingBox,
        );
        expect(
          () => geometry.update([], boundingBox),
          returnsNormally,
        );
      });

      test('return normally when keypoints are given', () {
        final keypoints = List.generate(468, (_) => _FakeKeypoint(0, 0));
        final geometry = RightEyeGeometry(
          keypoints: keypoints,
          boundingBox: boundingBox,
        );
        expect(
          () => geometry.update(keypoints, boundingBox),
          returnsNormally,
        );
      });
    });

    group('supports value equality', () {
      test('when all properties are equal', () {
        final geometry1 = RightEyeGeometry(
          keypoints: const [],
          boundingBox: boundingBox,
        );
        final geometry2 = RightEyeGeometry(
          keypoints: const [],
          boundingBox: boundingBox,
        );

        expect(geometry1, equals(geometry2));
      });

      test('when keypoints are different', () {
        final geometry1 = RightEyeGeometry(
          keypoints: const [],
          boundingBox: boundingBox,
        );
        final geometry2 = RightEyeGeometry(
          keypoints: List.generate(468, (_) => _FakeKeypoint(0, 0)),
          boundingBox: boundingBox,
        );

        expect(geometry1, isNot(equals(geometry2)));
      });
    });

    group('isClosed', () {
      test('is false when no keypoints are given', () {
        final rightEyeGeometry = RightEyeGeometry(
          keypoints: const [],
          boundingBox: boundingBox,
        );

        expect(rightEyeGeometry.isClosed, isFalse);
      });

      group('trained', () {
        late RightEyeGeometry rightEyeGeometry;

        setUp(() {
          final dataSet = [
            fixtures.face1,
            fixtures.face2,
            fixtures.face3,
            fixtures.face4,
            fixtures.face5,
            fixtures.face6,
            fixtures.face7,
            fixtures.face8,
            fixtures.face9,
            fixtures.face10,
          ];
          var trainedRightEyeGeometry = RightEyeGeometry(
            keypoints: dataSet.first.keypoints,
            boundingBox: dataSet.first.boundingBox,
          );
          for (final face in dataSet.skip(1)) {
            trainedRightEyeGeometry = trainedRightEyeGeometry.update(
              face.keypoints,
              face.boundingBox,
            );
          }
          rightEyeGeometry = trainedRightEyeGeometry;
        });

        test('is false with face1', () {
          final face = fixtures.face1;
          final updatedRightEyeGeometry = rightEyeGeometry.update(
            face.keypoints,
            face.boundingBox,
          );

          expect(updatedRightEyeGeometry.isClosed, isFalse);
        });

        test('is false with face2', () {
          final face = fixtures.face2;
          final updatedRightEyeGeometry = rightEyeGeometry.update(
            face.keypoints,
            face.boundingBox,
          );

          expect(updatedRightEyeGeometry.isClosed, isFalse);
        });

        test('is false with face3', () {
          final face = fixtures.face3;
          final updatedRightEyeGeometry = rightEyeGeometry.update(
            face.keypoints,
            face.boundingBox,
          );

          expect(updatedRightEyeGeometry.isClosed, isFalse);
        });

        test('is true with face4', () {
          final face = fixtures.face4;
          final updatedRightEyeGeometry = rightEyeGeometry.update(
            face.keypoints,
            face.boundingBox,
          );

          expect(updatedRightEyeGeometry.isClosed, isTrue);
        });

        test('is false with face5', () {
          final face = fixtures.face5;
          final updatedRightEyeGeometry = rightEyeGeometry.update(
            face.keypoints,
            face.boundingBox,
          );

          expect(updatedRightEyeGeometry.isClosed, isFalse);
        });

        test('is false with face6', () {
          final face = fixtures.face6;
          final updatedRightEyeGeometry = rightEyeGeometry.update(
            face.keypoints,
            face.boundingBox,
          );

          expect(updatedRightEyeGeometry.isClosed, isFalse);
        });

        test('is false with face7', () {
          final face = fixtures.face7;
          final updatedRightEyeGeometry = rightEyeGeometry.update(
            face.keypoints,
            face.boundingBox,
          );

          expect(updatedRightEyeGeometry.isClosed, isFalse);
        });

        test('is false with face8', () {
          final face = fixtures.face8;
          final updatedRightEyeGeometry = rightEyeGeometry.update(
            face.keypoints,
            face.boundingBox,
          );

          expect(updatedRightEyeGeometry.isClosed, isFalse);
        });

        test('is true with face9', () {
          final face = fixtures.face9;
          final updatedRightEyeGeometry = rightEyeGeometry.update(
            face.keypoints,
            face.boundingBox,
          );

          expect(updatedRightEyeGeometry.isClosed, isTrue);
        });

        test('is true with face10', () {
          final face = fixtures.face10;
          final updatedRightEyeGeometry = rightEyeGeometry.update(
            face.keypoints,
            face.boundingBox,
          );

          expect(updatedRightEyeGeometry.isClosed, isTrue);
        });
      });
    });
  });
}
