import 'package:flutter_test/flutter_test.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

void main() {
  group('Keypoint', () {
    test('can be instantiated', () {
      expect(
        Keypoint(1, 1, 1, 1, 'name'),
        isA<Keypoint>(),
      );
    });

    group('copyWith', () {
      test('returns normally', () {
        final subject = Keypoint(1, 1, 1, 1, 'name');
        expect(subject.copyWith, returnsNormally);
      });

      test('changes when properties are defined', () {
        final subject = Keypoint(1, 1, 1, 1, 'name');
        final copy = subject.copyWith(
          x: subject.x + 1,
          y: subject.y + 1,
          z: (subject.z ?? 0) + 1,
          score: (subject.score ?? 0) + 1,
          name: '${subject.name} copy',
        );

        expect(subject.x, isNot(equals(copy.x)));
        expect(subject.y, isNot(equals(copy.y)));
        expect(subject.z, isNot(equals(copy.z)));
        expect(subject.score, isNot(equals(copy.score)));
        expect(subject.name, isNot(equals(copy.name)));
      });

      test('remains the same if no changes are made', () {
        final subject = Keypoint(1, 1, 1, 1, 'name');
        final copy = subject.copyWith();

        expect(copy.x, equals(copy.x));
        expect(copy.y, equals(copy.y));
        expect(copy.z, equals(copy.z));
        expect(copy.score, equals(copy.score));
        expect(copy.name, equals(copy.name));
      });
    });
  });
}
