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

    group('isClosed', () {
      test('is false when no keypoints are given', () {
        final rightEyeGeometry = RightEyeGeometry(
          keypoints: const [],
          boundingBox: boundingBox,
        );

        expect(rightEyeGeometry.isClosed, isFalse);
      });

      group('untrained', () {
        test('is false with face1', () {
          final face = fixtures.face1;
          final rightEyeGeometry = RightEyeGeometry(
            keypoints: face.keypoints,
            boundingBox: face.boundingBox,
          );

          expect(rightEyeGeometry.isClosed, isFalse);
        });

        test('is false with face2', () {
          final face = fixtures.face2;
          final rightEyeGeometry = RightEyeGeometry(
            keypoints: face.keypoints,
            boundingBox: face.boundingBox,
          );

          expect(rightEyeGeometry.isClosed, isFalse);
        });

        test('is false with face3', () {
          final face = fixtures.face3;
          final rightEyeGeometry = RightEyeGeometry(
            keypoints: face.keypoints,
            boundingBox: face.boundingBox,
          );

          expect(rightEyeGeometry.isClosed, isFalse);
        });

        test('is false with face4', () {
          final face = fixtures.face4;
          final rightEyeGeometry = RightEyeGeometry(
            keypoints: face.keypoints,
            boundingBox: face.boundingBox,
          );

          expect(rightEyeGeometry.isClosed, isFalse);
        });

        test('is true with face5', () {
          final face = fixtures.face5;
          final rightEyeGeometry = RightEyeGeometry(
            keypoints: face.keypoints,
            boundingBox: face.boundingBox,
          );

          expect(rightEyeGeometry.isClosed, isTrue);
        });

        test('is false with face6', () {
          final face = fixtures.face6;
          final rightEyeGeometry = RightEyeGeometry(
            keypoints: face.keypoints,
            boundingBox: face.boundingBox,
          );

          expect(rightEyeGeometry.isClosed, isFalse);
        });

        test('is false with face7', () {
          final face = fixtures.face7;
          final rightEyeGeometry = RightEyeGeometry(
            keypoints: face.keypoints,
            boundingBox: face.boundingBox,
          );

          expect(rightEyeGeometry.isClosed, isFalse);
        });

        test('is false with face8', () {
          final face = fixtures.face8;
          final rightEyeGeometry = RightEyeGeometry(
            keypoints: face.keypoints,
            boundingBox: face.boundingBox,
          );

          expect(rightEyeGeometry.isClosed, isFalse);
        });

        test('is false with face9', () {
          final face = fixtures.face8;
          final rightEyeGeometry = RightEyeGeometry(
            keypoints: face.keypoints,
            boundingBox: face.boundingBox,
          );

          expect(rightEyeGeometry.isClosed, isFalse);
        });
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
          ];
          rightEyeGeometry = RightEyeGeometry(
            keypoints: dataSet.first.keypoints,
            boundingBox: dataSet.first.boundingBox,
          );
          for (final face in dataSet.skip(1)) {
            rightEyeGeometry.update(
              face.keypoints,
              face.boundingBox,
            );
          }
        });

        test('is false with face1', () {
          final face = fixtures.face1;
          rightEyeGeometry.update(
            face.keypoints,
            face.boundingBox,
          );

          expect(rightEyeGeometry.isClosed, isFalse);
        });
      });
    });
  });
}
