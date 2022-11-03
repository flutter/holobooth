import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Avatar', () {
    test('supports value comparison', () {
      const avatar1 = Avatar(hasMouthOpen: true, direction: Vector3.zero);
      const avatar2 = Avatar(hasMouthOpen: true, direction: Vector3.zero);
      const avatar3 = Avatar(hasMouthOpen: false, direction: Vector3.zero);
      const avatar4 = Avatar(hasMouthOpen: true, direction: Vector3(1, 0, 0));
      expect(avatar1, equals(avatar2));
      expect(avatar1, isNot(avatar3));
      expect(avatar1, isNot(avatar4));
    });
  });
}
