import 'dart:collection';

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
  late MouthGeometry mouthGeometry;
  late BoundingBox boundingBox;

  setUp(() {
    boundingBox = _MockBoundingBox();
    when(() => boundingBox.height).thenReturn(100);
  });

  group('MouthGeometry', () {
    test('supports equality', () {
      final mouth = MouthGeometry(const [], boundingBox);
      final mouth2 = MouthGeometry(const [], boundingBox);

      expect(mouth, equals(mouth2));
      expect(mouth, isNot(same(mouth2)));
    });

    test('update changes MouthGeometry', () {
      final mouth = MouthGeometry(const [], boundingBox);
      final mouth2 = MouthGeometry(const [], boundingBox);
      final newKeypoints = UnmodifiableListView(
        <Keypoint>[_FakeKeypoint(1, 1)],
      );

      mouth.update(newKeypoints, boundingBox);

      expect(mouth.keypoints, equals(newKeypoints));
      expect(mouth, isNot(mouth2));
    });

    group('mouthDistance', () {
      test('returns normally', () {
        final keypoints = UnmodifiableListView(
          List.generate(15, (_) => _FakeKeypoint(0, 0)),
        );
        mouthGeometry = MouthGeometry(keypoints, boundingBox);

        expect(() => mouthGeometry.mouthDistance, returnsNormally);
      });

      group('returns correct distance', () {
        test('when values are 0', () {
          final keypoints = UnmodifiableListView(
            List.generate(15, (_) => _FakeKeypoint(0, 0)),
          );
          mouthGeometry = MouthGeometry(keypoints, boundingBox);

          expect(mouthGeometry.mouthDistance, equals(0));
        });

        test('when values are not 0', () {
          final keypoints = List.generate(15, (_) => _FakeKeypoint(0, 0));
          keypoints[13] = _FakeKeypoint(-2, 2);
          keypoints[14] = _FakeKeypoint(1, -1);
          mouthGeometry = MouthGeometry(keypoints, boundingBox);

          expect(
            mouthGeometry.mouthDistance,
            equals(4.242640687119285),
          );
        });
      });
    });

    group('isMouthOpen', () {
      test('returns normally', () {
        final keypoints = UnmodifiableListView(
          List.generate(15, (_) => _FakeKeypoint(0, 0)),
        );
        mouthGeometry = MouthGeometry(keypoints, boundingBox);

        expect(() => mouthGeometry.isMouthOpen, returnsNormally);
      });

      test('is false with face1', () {
        final face = fixtures.face1;
        mouthGeometry = MouthGeometry(face.keypoints, face.boundingBox);

        expect(mouthGeometry.isMouthOpen, isFalse);
      });

      test('is true with face2', () {
        final face = fixtures.face2;
        mouthGeometry = MouthGeometry(face.keypoints, face.boundingBox);

        expect(mouthGeometry.isMouthOpen, isTrue);
      });

      test('is true with face3', () {
        final face = fixtures.face3;
        mouthGeometry = MouthGeometry(face.keypoints, face.boundingBox);

        expect(mouthGeometry.isMouthOpen, isTrue);
      });

      test('is false with face4', () {
        final face = fixtures.face4;
        mouthGeometry = MouthGeometry(face.keypoints, face.boundingBox);

        expect(mouthGeometry.isMouthOpen, isFalse);
      });

      test('is false with face5', () {
        final face = fixtures.face5;
        mouthGeometry = MouthGeometry(face.keypoints, face.boundingBox);

        expect(mouthGeometry.isMouthOpen, isFalse);
      });

      test('is false with face6', () {
        final face = fixtures.face6;
        mouthGeometry = MouthGeometry(face.keypoints, face.boundingBox);

        expect(mouthGeometry.isMouthOpen, isFalse);
      });

      test('is true with face7', () {
        final face = fixtures.face7;
        mouthGeometry = MouthGeometry(face.keypoints, face.boundingBox);

        expect(mouthGeometry.isMouthOpen, isTrue);
      });

      test('is true with face8', () {
        final face = fixtures.face8;
        mouthGeometry = MouthGeometry(face.keypoints, face.boundingBox);

        expect(mouthGeometry.isMouthOpen, isTrue);
      });

      test('is false with face9', () {
        final face = fixtures.face9;
        mouthGeometry = MouthGeometry(face.keypoints, face.boundingBox);

        expect(mouthGeometry.isMouthOpen, isFalse);
      });
    });
  });
}
