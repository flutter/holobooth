import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Avatar', () {
    test('supports value comparison', () {
      const avatar1 = Avatar(
        hasMouthOpen: true,
        mouthDistance: 0,
        direction: Vector3.zero,
        leftEyeGeometry: LeftEyeGeometry.empty(),
        rightEyeGeometry: RightEyeGeometry.empty(),
        distance: 0,
      );
      const avatar2 = Avatar(
        hasMouthOpen: true,
        mouthDistance: 0,
        direction: Vector3.zero,
        leftEyeGeometry: LeftEyeGeometry.empty(),
        rightEyeGeometry: RightEyeGeometry.empty(),
        distance: 0,
      );
      const avatar3 = Avatar(
        hasMouthOpen: false,
        mouthDistance: 1,
        direction: Vector3(1, 0, 0),
        leftEyeGeometry: LeftEyeGeometry.empty(),
        rightEyeGeometry: RightEyeGeometry.empty(),
        distance: 1,
      );

      expect(avatar1, equals(avatar2));
      expect(avatar1, isNot(avatar3));
      expect(avatar2, isNot(avatar3));
    });
  });
}
