import 'dart:collection';

import 'package:face_geometry/face_geometry.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:test/test.dart';

class _MockFace extends Mock implements Face {}

class _MockBoundingBox extends Mock implements BoundingBox {}

class _FakeKeypoint extends Fake implements Keypoint {
  _FakeKeypoint(this.x, this.y);

  @override
  final double x;

  @override
  final double y;
}

void main() {
  late Face face;
  late BoundingBox boundingBox;

  setUp(() {
    boundingBox = _MockBoundingBox();
    face = _MockFace();

    when(() => boundingBox.height).thenReturn(100);
    when(() => face.boundingBox).thenReturn(boundingBox);
  });

  group('MouthGeometry', () {
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

          expect(
            face.mouthDistance,
            equals(4.242640687119285),
          );
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
