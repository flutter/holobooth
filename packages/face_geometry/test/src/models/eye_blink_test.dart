import 'package:face_geometry/face_geometry.dart';
import 'package:test/test.dart';

void main() {
  group('EyeBlink', () {
    test('can be initialized', () {
      final eyeBlink = EyeBlink(
        maxRatio: 1,
        minRatio: 0,
        firstAction: true,
      );

      expect(eyeBlink.maxRatio, 1.0);
      expect(eyeBlink.minRatio, 0.0);
      expect(eyeBlink.firstAction, true);
    });

    test('copyWith should create a new instance', () {
      final eyeBlink = EyeBlink();
      final copy = eyeBlink.copyWith();
      expect(copy, isNotNull);
      expect(copy, isNot(eyeBlink));
    });
  });
}
