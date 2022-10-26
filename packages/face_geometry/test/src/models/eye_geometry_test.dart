import 'dart:collection';

import 'package:face_geometry/face_geometry.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:test/test.dart';

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
    when(() => boundingBox.height).thenReturn(100);
  });

  group('EyeGeometry', () {
    test('can be initialized', () {
      expect(
        () => EyeGeometry.left(const <Keypoint>[], _MockBoundingBox()),
        returnsNormally,
      );

      expect(
        () => EyeGeometry.right(const <Keypoint>[], _MockBoundingBox()),
        returnsNormally,
      );
    });

    test('supports equality', () {
      const keypoints = <Keypoint>[];
      final eye = EyeGeometry.left(keypoints, boundingBox);
      final eye2 = EyeGeometry.left(keypoints, boundingBox);
      final eye3 = EyeGeometry.left(
        <Keypoint>[_FakeKeypoint(0, 0)],
        _MockBoundingBox(),
      );

      expect(eye, equals(eye2));
      expect(eye, isNot(equals(eye3)));
    });

    group('leftEye.distance', () {
      test('returns normally', () {
        final keypoints = UnmodifiableListView(
          List.generate(160, (_) => _FakeKeypoint(0, 0)),
        );

        final eye = EyeGeometry.left(keypoints, boundingBox);

        expect(() => eye.distance, returnsNormally);
      });

      test('returns 0 when missing keypoints', () {
        final eye = EyeGeometry.left(UnmodifiableListView([]), boundingBox);

        expect(eye.distance, equals(0));
      });

      group('returns correct distance', () {
        test('when values are 0', () {
          final keypoints = UnmodifiableListView(
            List.generate(160, (_) => _FakeKeypoint(0, 0)),
          );
          final eye = EyeGeometry.left(keypoints, boundingBox);

          expect(eye.distance, equals(0));
        });

        test('when values are not 0', () {
          final keypoints = List.generate(160, (_) => _FakeKeypoint(0, 0));
          keypoints[159] = _FakeKeypoint(-2, 2);
          keypoints[145] = _FakeKeypoint(1, -1);

          final eye = EyeGeometry.left(keypoints, boundingBox);

          expect(eye.distance, equals(4.242640687119285));
        });
      });
    });

    group('rightEye.distance', () {
      test('returns normally', () {
        final keypoints = UnmodifiableListView(
          List.generate(387, (_) => _FakeKeypoint(0, 0)),
        );
        final eye = EyeGeometry.right(keypoints, boundingBox);

        expect(() => eye.distance, returnsNormally);
      });

      test('returns 0 when missing keypoints', () {
        final eye = EyeGeometry.right(UnmodifiableListView([]), boundingBox);

        expect(eye.distance, equals(0));
      });

      group('returns correct distance', () {
        test('when values are 0', () {
          final keypoints = UnmodifiableListView(
            List.generate(387, (_) => _FakeKeypoint(0, 0)),
          );
          final eye = EyeGeometry.right(keypoints, boundingBox);

          expect(eye.distance, equals(0));
        });

        test('when values are not 0', () {
          final keypoints = List.generate(387, (_) => _FakeKeypoint(0, 0));
          keypoints[386] = _FakeKeypoint(-2, 2);
          keypoints[374] = _FakeKeypoint(1, -1);
          final eye = EyeGeometry.right(keypoints, boundingBox);

          expect(eye.distance, equals(4.242640687119285));
        });
      });
    });

    group('leftEye.isClose', () {
      test('returns normally', () {
        final keypoints = UnmodifiableListView(
          List.generate(387, (_) => _FakeKeypoint(0, 0)),
        );
        final eye = EyeGeometry.left(keypoints, boundingBox);

        expect(() => eye.isClose, returnsNormally);
      });

      test('returns false when missing keypoints', () {
        final eye = EyeGeometry.left(UnmodifiableListView([]), boundingBox);

        expect(eye.isClose, equals(false));
      });

      group('returns correct value', () {
        test('when values are 0', () {
          final keypoints = UnmodifiableListView(
            List.generate(387, (_) => _FakeKeypoint(0, 0)),
          );
          final eye = EyeGeometry.left(keypoints, boundingBox);

          expect(eye.isClose, equals(false));
        });

        test('for first check', () {
          final keypoints = List.generate(387, (_) => _FakeKeypoint(0, 0));
          keypoints[159] = _FakeKeypoint(30, 2);
          keypoints[145] = _FakeKeypoint(10, -1);

          final eye = EyeGeometry.left(keypoints, boundingBox);

          expect(eye.isClose, equals(false));
        });

        test('for second check with close', () {
          final keypoints = List.generate(387, (_) => _FakeKeypoint(0, 0));
          keypoints[159] = _FakeKeypoint(30, 2);
          keypoints[145] = _FakeKeypoint(10, -1);

          final eye = EyeGeometry.left(keypoints, boundingBox);

          expect(eye.isClose, equals(false));

          keypoints[159] = _FakeKeypoint(12, 2);
          keypoints[145] = _FakeKeypoint(10, -1);

          eye.update(keypoints, boundingBox);

          expect(eye.isClose, equals(true));
        });
      });
    });

    group('rightEye.isClose', () {
      test('returns normally', () {
        final keypoints = UnmodifiableListView(
          List.generate(387, (_) => _FakeKeypoint(0, 0)),
        );

        final eye = EyeGeometry.right(keypoints, boundingBox);

        expect(() => eye.isClose, returnsNormally);
      });

      test('returns false when missing keypoints', () {
        final eye = EyeGeometry.right(UnmodifiableListView([]), boundingBox);

        expect(eye.isClose, equals(false));
      });

      group('returns correct value', () {
        test('when values are 0', () {
          final keypoints = UnmodifiableListView(
            List.generate(387, (_) => _FakeKeypoint(0, 0)),
          );
          final eye = EyeGeometry.right(keypoints, boundingBox);

          expect(eye.isClose, equals(false));
        });

        test('for first check', () {
          final keypoints = List.generate(387, (_) => _FakeKeypoint(0, 0));
          keypoints[386] = _FakeKeypoint(30, 2);
          keypoints[374] = _FakeKeypoint(10, -1);

          final eye = EyeGeometry.right(keypoints, boundingBox);

          expect(eye.isClose, equals(false));
        });

        test('for second check with close', () {
          final keypoints = List.generate(387, (_) => _FakeKeypoint(0, 0));
          keypoints[386] = _FakeKeypoint(30, 2);
          keypoints[374] = _FakeKeypoint(10, -1);

          final eye = EyeGeometry.right(keypoints, boundingBox);

          expect(eye.isClose, equals(false));

          keypoints[386] = _FakeKeypoint(12, 2);
          keypoints[374] = _FakeKeypoint(10, -1);

          eye.update(keypoints, boundingBox);

          expect(eye.isClose, equals(true));
        });
      });
    });
  });
}
