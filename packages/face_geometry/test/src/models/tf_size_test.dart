import 'package:face_geometry/face_geometry.dart';
import 'package:test/test.dart';

void main() {
  group('TFSize', () {
    test('can be initialize', () {
      final tfSize = TFSize(1, 2);
      expect(tfSize.width, 1);
      expect(tfSize.height, 2);
    });
  });
}
