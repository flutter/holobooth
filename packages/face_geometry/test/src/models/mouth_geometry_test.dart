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
  late BoundingBox boundingBox;

  setUp(() {
    boundingBox = _MockBoundingBox();
    when(() => boundingBox.height).thenReturn(0);
  });

  group('MouthGeometry', () {
    group('factory constructor', () {
      test('returns normally when no keypoints are given', () {
        expect(
          () => MouthGeometry(
            keypoints: const [],
            boundingBox: boundingBox,
          ),
          returnsNormally,
        );
      });

      test('returns normally when keypoints are given', () {
        final keypoints = List.generate(468, (_) => _FakeKeypoint(0, 0));
        expect(
          () => MouthGeometry(
            keypoints: keypoints,
            boundingBox: boundingBox,
          ),
          returnsNormally,
        );
      });
    });

    group('isOpen', () {
      test('is false when no keypoints are given', () {
        final mouthGeometry = MouthGeometry(
          keypoints: const [],
          boundingBox: boundingBox,
        );

        expect(mouthGeometry.isOpen, isFalse);
      });

      test('is false with face1', () {
        final face = fixtures.face1;
        final mouthGeometry = MouthGeometry(
          keypoints: face.keypoints,
          boundingBox: face.boundingBox,
        );

        expect(mouthGeometry.isOpen, isFalse);
      });

      test('is true with face2', () {
        final face = fixtures.face2;
        final mouthGeometry = MouthGeometry(
          keypoints: face.keypoints,
          boundingBox: face.boundingBox,
        );

        expect(mouthGeometry.isOpen, isTrue);
      });

      test('is true with face3', () {
        final face = fixtures.face3;
        final mouthGeometry = MouthGeometry(
          keypoints: face.keypoints,
          boundingBox: face.boundingBox,
        );

        expect(mouthGeometry.isOpen, isTrue);
      });

      test('is false with face4', () {
        final face = fixtures.face4;
        final mouthGeometry = MouthGeometry(
          keypoints: face.keypoints,
          boundingBox: face.boundingBox,
        );

        expect(mouthGeometry.isOpen, isFalse);
      });

      test('is false with face5', () {
        final face = fixtures.face5;
        final mouthGeometry = MouthGeometry(
          keypoints: face.keypoints,
          boundingBox: face.boundingBox,
        );

        expect(mouthGeometry.isOpen, isFalse);
      });

      test('is false with face6', () {
        final face = fixtures.face6;
        final mouthGeometry = MouthGeometry(
          keypoints: face.keypoints,
          boundingBox: face.boundingBox,
        );

        expect(mouthGeometry.isOpen, isFalse);
      });

      test('is true with face7', () {
        final face = fixtures.face7;
        final mouthGeometry = MouthGeometry(
          keypoints: face.keypoints,
          boundingBox: face.boundingBox,
        );

        expect(mouthGeometry.isOpen, isTrue);
      });

      test('is true with face8', () {
        final face = fixtures.face8;
        final mouthGeometry = MouthGeometry(
          keypoints: face.keypoints,
          boundingBox: face.boundingBox,
        );

        expect(mouthGeometry.isOpen, isTrue);
      });

      test('is false with face9', () {
        final face = fixtures.face9;
        final mouthGeometry = MouthGeometry(
          keypoints: face.keypoints,
          boundingBox: face.boundingBox,
        );

        expect(mouthGeometry.isOpen, isFalse);
      });
    });
  });
}
