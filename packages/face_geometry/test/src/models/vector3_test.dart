import 'package:face_geometry/face_geometry.dart';
import 'package:test/test.dart';

void main() {
  group('Vector3', () {
    test('can be instantiated', () {
      expect(const Vector3(0, 0, 1), isA<Vector3>());
    });

    group('unit', () {
      test('returns normally', () {
        const vector = Vector3(1, 1, 1);
        expect(vector.unit, returnsNormally);
      });

      test('returns a unit vector', () {
        const vector = Vector3(1, 1, 1);
        final result = vector.unit();

        expect(result.x.toStringAsFixed(2), equals('0.58'));
        expect(result.y.toStringAsFixed(2), equals('0.58'));
        expect(result.z.toStringAsFixed(2), equals('0.58'));
      });
    });

    group('* operator', () {
      test('returns normally', () {
        const vector = Vector3(1, 2, 3);
        expect(vector * 1, isA<Vector3>());
      });

      test('returns correct vector', () {
        const vector = Vector3(1, 2, 3);
        const scalar = 2.0;
        final result = vector * scalar;

        expect(result.x, equals(vector.x * scalar));
        expect(result.y, equals(vector.y * scalar));
        expect(result.z, equals(vector.z * scalar));
      });
    });

    test('supports value comparison', () {
      const vector1 = Vector3(0, 0, 1);
      const vector2 = Vector3(0, 0, 1);
      const vector3 = Vector3(1, 1, 1);
      expect(vector1, equals(vector2));
      expect(vector1, isNot(vector3));
    });
  });

  group('toString', () {
    test('returns normally', () {
      expect(const Vector3(1, 2, 3).toString, returnsNormally);
    });

    test('returns correct string', () {
      expect(
        const Vector3(1, 2, 3).toString(),
        equals('Vector3(1.0, 2.0, 3.0)'),
      );
    });
  });
}
