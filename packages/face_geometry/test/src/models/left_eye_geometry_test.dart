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
  group('LeftEyeGeometry', () {
    late BoundingBox boundingBox;

    setUp(() {
      boundingBox = _MockBoundingBox();
      when(() => boundingBox.height).thenReturn(0);
    });

    group('factory constructor', () {
      test('returns normally when no keypoints are given', () {
        expect(
          () => LeftEyeGeometry(
            keypoints: const [],
            boundingBox: boundingBox,
          ),
          returnsNormally,
        );
      });

      test('returns normally when keypoints are given', () {
        final keypoints = List.generate(468, (_) => _FakeKeypoint(0, 0));
        expect(
          () => LeftEyeGeometry(
            keypoints: keypoints,
            boundingBox: boundingBox,
          ),
          returnsNormally,
        );
      });
    });

    group('isClosed', () {
      test('is false when no keypoints are given', () {
        final leftEyeGeometry = LeftEyeGeometry(
          keypoints: const [],
          boundingBox: boundingBox,
        );

        expect(leftEyeGeometry.isClosed, isFalse);
      });

      group('trained', () {
        late LeftEyeGeometry leftEyeGeometry;

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
          var trainedLeftEyeGeometry = LeftEyeGeometry(
            keypoints: dataSet.first.keypoints,
            boundingBox: dataSet.first.boundingBox,
          );
          for (final face in dataSet.skip(1)) {
            trainedLeftEyeGeometry = trainedLeftEyeGeometry.update(
              face.keypoints,
              face.boundingBox,
            );
          }
          leftEyeGeometry = trainedLeftEyeGeometry;
        });

        test('is false with face1', () {
          final face = fixtures.face1;
          final updatedLeftEyeGeometry = leftEyeGeometry.update(
            face.keypoints,
            face.boundingBox,
          );

          expect(updatedLeftEyeGeometry.isClosed, isFalse);
        });

        test('is false with face2', () {
          final face = fixtures.face2;
          final updatedLeftEyeGeometry = leftEyeGeometry.update(
            face.keypoints,
            face.boundingBox,
          );

          expect(updatedLeftEyeGeometry.isClosed, isFalse);
        });

        test('is false with face3', () {
          final face = fixtures.face3;
          final updatedLeftEyeGeometry = leftEyeGeometry.update(
            face.keypoints,
            face.boundingBox,
          );

          expect(updatedLeftEyeGeometry.isClosed, isFalse);
        });

        test('is false with face4', () {
          final face = fixtures.face4;
          final updatedLeftEyeGeometry = leftEyeGeometry.update(
            face.keypoints,
            face.boundingBox,
          );

          expect(updatedLeftEyeGeometry.isClosed, isFalse);
        });

        test('is true with face5', () {
          final face = fixtures.face5;
          final updatedLeftEyeGeometry = leftEyeGeometry.update(
            face.keypoints,
            face.boundingBox,
          );

          expect(updatedLeftEyeGeometry.isClosed, isTrue);
        });

        test('is false with face6', () {
          final face = fixtures.face6;
          final updatedLeftEyeGeometry = leftEyeGeometry.update(
            face.keypoints,
            face.boundingBox,
          );

          expect(updatedLeftEyeGeometry.isClosed, isFalse);
        });

        test('is false with face7', () {
          final face = fixtures.face7;
          final updatedLeftEyeGeometry = leftEyeGeometry.update(
            face.keypoints,
            face.boundingBox,
          );

          expect(updatedLeftEyeGeometry.isClosed, isFalse);
        });

        test('is false with face8', () {
          final face = fixtures.face8;
          final updatedLeftEyeGeometry = leftEyeGeometry.update(
            face.keypoints,
            face.boundingBox,
          );

          expect(updatedLeftEyeGeometry.isClosed, isFalse);
        });

        test('is false with face9', () {
          final face = fixtures.face9;
          final updatedLeftEyeGeometry = leftEyeGeometry.update(
            face.keypoints,
            face.boundingBox,
          );

          expect(updatedLeftEyeGeometry.isClosed, isFalse);
        });

        test('is true with face10', () {
          final face = fixtures.face10;
          final updatedLeftEyeGeometry = leftEyeGeometry.update(
            face.keypoints,
            face.boundingBox,
          );

          expect(updatedLeftEyeGeometry.isClosed, isTrue);
        });
      });
    });
  });
}
