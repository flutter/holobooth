import 'dart:collection';

import 'package:face_geometry/face_geometry.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;
import 'package:test/test.dart';

class _MockFace extends Mock implements tf.Face {}

class _MockBoundingBox extends Mock implements tf.BoundingBox {}

class _FakeKeypoint extends Fake implements tf.Keypoint {
  _FakeKeypoint(this.x, this.y);

  @override
  final double x;

  @override
  final double y;
}

void main() {
  group('FaceGeometry', () {
    late tf.Face face;

    setUp(() {
      face = _MockFace();
    });

    group('mouthDistance', () {
      test('returns normally', () {
        final keypoints = UnmodifiableListView(
          List.generate(15, (_) => _FakeKeypoint(0, 0)),
        );
        when(() => face.keypoints).thenReturn(keypoints);

        expect(() => face.mouthDistance, returnsNormally);
      });

      group('returns correct distance', () {
        test('when values are 0', () {
          final keypoints = UnmodifiableListView(
            List.generate(15, (_) => _FakeKeypoint(0, 0)),
          );
          when(() => face.keypoints).thenReturn(keypoints);

          expect(face.mouthDistance, equals(0));
        });

        test('when values are not 0', () {
          final keypoints = List.generate(15, (_) => _FakeKeypoint(0, 0));
          keypoints[13] = _FakeKeypoint(-2, 2);
          keypoints[14] = _FakeKeypoint(1, -1);
          when(() => face.keypoints)
              .thenReturn(UnmodifiableListView(keypoints));

          expect(face.mouthDistance, equals(4.242640687119285));
        });
      });
    });

    group('leftEyeDistance', () {
      test('returns normally', () {
        final keypoints = UnmodifiableListView(
          List.generate(160, (_) => _FakeKeypoint(0, 0)),
        );
        when(() => face.keypoints).thenReturn(keypoints);

        expect(() => face.leftEyeDistance, returnsNormally);
      });

      test('returns 0 when missing keypoints', () {
        when(() => face.keypoints).thenReturn(UnmodifiableListView([]));
        expect(face.leftEyeDistance, equals(0));
      });

      group('returns correct distance', () {
        test('when values are 0', () {
          final keypoints = UnmodifiableListView(
            List.generate(160, (_) => _FakeKeypoint(0, 0)),
          );
          when(() => face.keypoints).thenReturn(keypoints);

          expect(face.leftEyeDistance, equals(0));
        });

        test('when values are not 0', () {
          final keypoints = List.generate(160, (_) => _FakeKeypoint(0, 0));
          keypoints[159] = _FakeKeypoint(-2, 2);
          keypoints[145] = _FakeKeypoint(1, -1);
          when(() => face.keypoints)
              .thenReturn(UnmodifiableListView(keypoints));

          expect(face.leftEyeDistance, equals(4.242640687119285));
        });
      });
    });

    group('rightEyeDistance', () {
      test('returns normally', () {
        final keypoints = UnmodifiableListView(
          List.generate(387, (_) => _FakeKeypoint(0, 0)),
        );
        when(() => face.keypoints).thenReturn(keypoints);

        expect(() => face.rightEyeDistance, returnsNormally);
      });

      test('returns 0 when missing keypoints', () {
        when(() => face.keypoints).thenReturn(UnmodifiableListView([]));
        expect(face.rightEyeDistance, equals(0));
      });

      group('returns correct distance', () {
        test('when values are 0', () {
          final keypoints = UnmodifiableListView(
            List.generate(387, (_) => _FakeKeypoint(0, 0)),
          );
          when(() => face.keypoints).thenReturn(keypoints);

          expect(face.rightEyeDistance, equals(0));
        });

        test('when values are not 0', () {
          final keypoints = List.generate(387, (_) => _FakeKeypoint(0, 0));
          keypoints[386] = _FakeKeypoint(-2, 2);
          keypoints[374] = _FakeKeypoint(1, -1);
          when(() => face.keypoints)
              .thenReturn(UnmodifiableListView(keypoints));

          expect(face.rightEyeDistance, equals(4.242640687119285));
        });
      });
    });

    group('isMouthOpen', () {
      setUp(() {
        final boundingBox = _MockBoundingBox();
        when(() => boundingBox.height).thenReturn(100);
        when(() => face.boundingBox).thenReturn(boundingBox);
      });

      test('returns normally', () {
        final keypoints = UnmodifiableListView(
          List.generate(15, (_) => _FakeKeypoint(0, 0)),
        );
        when(() => face.keypoints).thenReturn(keypoints);

        expect(() => face.isMouthOpen, returnsNormally);
      });

      group('returns correct distance', () {
        test('when values are 0', () {
          final keypoints = UnmodifiableListView(
            List.generate(15, (_) => _FakeKeypoint(0, 0)),
          );
          when(() => face.keypoints).thenReturn(keypoints);

          expect(face.isMouthOpen, equals(false));
        });

        test('when values are not 0', () {
          final keypoints = List.generate(15, (_) => _FakeKeypoint(0, 0));
          keypoints[13] = _FakeKeypoint(-2, 2);
          keypoints[14] = _FakeKeypoint(1, -1);
          when(() => face.keypoints)
              .thenReturn(UnmodifiableListView(keypoints));

          expect(face.isMouthOpen, equals(true));
        });
      });
    });
  });
}
