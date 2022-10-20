// ignore_for_file: prefer_const_constructors

import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:test/test.dart';

void main() {
  group('EstimationConfig', () {
    test('can be instantiated', () {
      expect(
        EstimationConfig(),
        isA<EstimationConfig>(),
      );
    });

    group('flipHorizontal', () {
      test('false by default', () {
        expect(
          EstimationConfig().flipHorizontal,
          isFalse,
        );
      });
    });

    group('staticImageMode', () {
      test('true by default', () {
        expect(
          EstimationConfig().staticImageMode,
          isTrue,
        );
      });
    });
  });
}
