import 'dart:collection';

import 'package:face_geometry/face_geometry.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;
import 'package:test/test.dart';

class _MockFace extends Mock implements tf.Face {}

class _FakeKeypoint extends Fake implements tf.Keypoint {
  _FakeKeypoint(this.x, this.y, this.z);

  @override
  final double x;

  @override
  final double y;

  @override
  final double? z;
}

void main() {
  group('FaceDirection', () {
    late tf.Face face;
    late FaceGeometry faceGeometry;

    setUp(() {
      face = _MockFace();
      faceGeometry = FaceGeometry(face);
    });

    group('direction', () {
      test('returns normally', () {
        final keypoints = UnmodifiableListView(
          List.generate(357, (_) => _FakeKeypoint(0, 0, 0)),
        );
        when(() => face.keypoints).thenReturn(keypoints);
        expect(faceGeometry.direction, returnsNormally);
      });
    });
  });
}
