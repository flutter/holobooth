import 'package:flutter_test/flutter_test.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

void main() {
  group('BoundingBox', () {
    test('can be instantiated', () {
      expect(
        BoundingBox(1, 1, 1, 1, 10, 10),
        isA<BoundingBox>(),
      );
    });

    group('copyWith', () {
      test('returns normally', () {
        final subject = BoundingBox(1, 1, 1, 1, 10, 10);
        expect(subject.copyWith, returnsNormally);
      });

      test('changes when properties are defined', () {
        final subject = BoundingBox(1, 1, 1, 1, 10, 10);
        final copy = subject.copyWith(
          xMin: subject.xMin + 1,
          yMin: subject.yMin + 1,
          xMax: subject.xMax + 1,
          yMax: subject.yMax + 1,
          width: subject.width + 1,
          height: subject.height + 1,
        );

        expect(subject.xMin, isNot(equals(copy.xMin)));
        expect(subject.yMin, isNot(equals(copy.yMin)));
        expect(subject.xMax, isNot(equals(copy.xMax)));
        expect(subject.yMax, isNot(equals(copy.yMax)));
        expect(subject.width, isNot(equals(copy.width)));
        expect(subject.height, isNot(equals(copy.height)));
      });

      test('remains the same if no changes are made', () {
        final subject = BoundingBox(1, 1, 1, 1, 10, 10);
        final copy = subject.copyWith();

        expect(subject.xMin, equals(copy.xMin));
        expect(subject.yMin, equals(copy.yMin));
        expect(subject.xMax, equals(copy.xMax));
        expect(subject.yMax, equals(copy.yMax));
        expect(subject.width, equals(copy.width));
        expect(subject.height, equals(copy.height));
      });
    });
  });
}
