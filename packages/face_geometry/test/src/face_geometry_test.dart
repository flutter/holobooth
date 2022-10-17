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

class _FakeKeypoint extends Fake implements tf.Keypoint {
  _FakeKeypoint(this.x, this.y);

  @override
  final double x;

  @override
  final double y;
}

void main() {
  setUpAll(() {
    registerFallbackValue(Size(0, 0));
  });

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

    group('isLeftEyeClose', () {
      setUp(() {
        final boundingBox = _MockBoundingBox();
        when(() => boundingBox.height).thenReturn(100);
        when(() => face.boundingBox).thenReturn(boundingBox);
      });

      test('returns normally', () {
        final keypoints = UnmodifiableListView(
          List.generate(387, (_) => _FakeKeypoint(0, 0)),
        );
        when(() => face.keypoints).thenReturn(keypoints);

        expect(() => face.isLeftEyeClose, returnsNormally);
      });

      test('returns false when missing keypoints', () {
        when(() => face.keypoints).thenReturn(UnmodifiableListView([]));
        expect(face.isLeftEyeClose, equals(false));
      });

      group('returns correct value', () {
        test('when values are 0', () {
          final keypoints = UnmodifiableListView(
            List.generate(387, (_) => _FakeKeypoint(0, 0)),
          );
          when(() => face.keypoints).thenReturn(keypoints);

          expect(face.isLeftEyeClose, equals(false));
        });

        test('for first check', () {
          final keypoints = List.generate(387, (_) => _FakeKeypoint(0, 0));
          keypoints[386] = _FakeKeypoint(30, 2);
          keypoints[374] = _FakeKeypoint(10, -1);
          when(() => face.keypoints)
              .thenReturn(UnmodifiableListView(keypoints));

          expect(face.isLeftEyeClose, equals(false));
        });

        test('for second check with close', () {
          final keypoints = List.generate(387, (_) => _FakeKeypoint(0, 0));
          keypoints[386] = _FakeKeypoint(30, 2);
          keypoints[374] = _FakeKeypoint(10, -1);
          when(() => face.keypoints)
              .thenReturn(UnmodifiableListView(keypoints));

          expect(face.isLeftEyeClose, equals(false));

          keypoints[386] = _FakeKeypoint(12, 2);
          keypoints[374] = _FakeKeypoint(10, -1);
          when(() => face.keypoints)
              .thenReturn(UnmodifiableListView(keypoints));

          expect(face.isLeftEyeClose, equals(true));
        });
      });
    });

    group('isRightEyeClose', () {
      setUp(() {
        final boundingBox = _MockBoundingBox();
        when(() => boundingBox.height).thenReturn(100);
        when(() => face.boundingBox).thenReturn(boundingBox);
      });

      test('returns normally', () {
        final keypoints = UnmodifiableListView(
          List.generate(387, (_) => _FakeKeypoint(0, 0)),
        );
        when(() => face.keypoints).thenReturn(keypoints);

        expect(() => face.isRightEyeClose, returnsNormally);
      });

      test('returns false when missing keypoints', () {
        when(() => face.keypoints).thenReturn(UnmodifiableListView([]));
        expect(face.isRightEyeClose, equals(false));
      });

      group('returns correct value', () {
        test('when values are 0', () {
          final keypoints = UnmodifiableListView(
            List.generate(387, (_) => _FakeKeypoint(0, 0)),
          );
          when(() => face.keypoints).thenReturn(keypoints);

          expect(face.isRightEyeClose, equals(false));
        });

        test('for first check', () {
          final keypoints = List.generate(387, (_) => _FakeKeypoint(0, 0));
          keypoints[159] = _FakeKeypoint(30, 2);
          keypoints[145] = _FakeKeypoint(10, -1);
          when(() => face.keypoints)
              .thenReturn(UnmodifiableListView(keypoints));

          expect(face.isRightEyeClose, equals(false));
        });

        test('for second check with close', () {
          final keypoints = List.generate(387, (_) => _FakeKeypoint(0, 0));
          keypoints[159] = _FakeKeypoint(30, 2);
          keypoints[145] = _FakeKeypoint(10, -1);
          when(() => face.keypoints)
              .thenReturn(UnmodifiableListView(keypoints));

          expect(face.isRightEyeClose, equals(false));

          keypoints[159] = _FakeKeypoint(12, 2);
          keypoints[145] = _FakeKeypoint(10, -1);
          when(() => face.keypoints)
              .thenReturn(UnmodifiableListView(keypoints));

          expect(face.isRightEyeClose, equals(true));
        });
      });
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

        test('Face BoundingBox', () {
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

        test('Face keypoints', () {
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

        test('Face when called on Faces', () {
          [face, face].normalize(
            fromMax: Size(20, 30),
            toMax: Size(40, 60),
          );

          verify(
            () => face.normalize(
              fromMax: Size(20, 30),
              toMax: Size(40, 60),
            ),
          ).called(2);
        });
      });
    });
  });
}
