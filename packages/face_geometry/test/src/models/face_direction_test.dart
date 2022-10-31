import 'dart:collection';

import 'package:face_geometry/face_geometry.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;
import 'package:test/test.dart';

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
    final list = List.generate(357, (_) => _FakeKeypoint(0, 0, 0));
    list[6] = _FakeKeypoint(10, 20, 30);
    list[127] = _FakeKeypoint(12, 13, 14);
    list[356] = _FakeKeypoint(33, 34, 35);
    final keypoints = UnmodifiableListView(list);

    group('constructor', () {
      test('returns normally', () {
        expect(FaceDirection(keypoints), returnsNormally);
      });
    });

    test('supports value equality', () {
      final direction = FaceDirection(keypoints);
      final direction2 = FaceDirection(keypoints);
      final direction3 = FaceDirection(
        UnmodifiableListView(
          List.generate(357, (_) => _FakeKeypoint(0, 0, 0)),
        ),
      );

      expect(direction, equals(direction2));
      expect(direction, isNot(same(direction2)));
      expect(direction, isNot(equals(direction3)));
    });
  });
}
