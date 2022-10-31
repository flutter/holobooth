import 'dart:collection';

import 'package:face_geometry/face_geometry.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:test/test.dart';

class _MockBoundingBox extends Mock implements BoundingBox {}

class _FakeKeypoint extends Fake implements Keypoint {
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
    late FaceDirection faceDirection;
    late BoundingBox boundingBox;
    final list = List.generate(357, (_) => _FakeKeypoint(0, 0, 0));
    list[6] = _FakeKeypoint(10, 20, 30);
    list[127] = _FakeKeypoint(12, 13, 14);
    list[356] = _FakeKeypoint(33, 34, 35);
    final keypoints = UnmodifiableListView(list);

    setUp(() {
      boundingBox = _MockBoundingBox();
      when(() => boundingBox.height).thenReturn(100);
      faceDirection = FaceDirection(keypoints, boundingBox);
    });

    group('direction', () {
      test('returns normally', () {
        expect(() => faceDirection.calculate, returnsNormally);
      });

      test('returns correct value', () {
        final vector = faceDirection.calculate();
        expect(vector, const Vector3(189, -378, 189));
      });
    });

    test('supports equality', () {
      final direction = faceDirection.calculate();
      final direction2 = faceDirection.calculate();

      expect(direction, equals(direction2));
      expect(direction, isNot(same(direction2)));
    });

    test('update changes FaceDirection', () {
      final direction = faceDirection;
      final direction2 = FaceDirection(keypoints, boundingBox);
      final newKeypoints = UnmodifiableListView(
        <Keypoint>[_FakeKeypoint(1, 1, 1)],
      );

      faceDirection.update(newKeypoints, boundingBox);

      expect(direction.keypoints, equals(newKeypoints));
      expect(direction, isNot(direction2));
    });
  });
}
