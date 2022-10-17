// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;

void main() {
  group('EstimationConfig', () {
    test('can be instantiated', () {
      expect(
        tf.EstimationConfig(),
        isA<tf.EstimationConfig>(),
      );
    });

    group('flipHorizontal', () {
      test('false by default', () {
        expect(
          tf.EstimationConfig().flipHorizontal,
          isFalse,
        );
      });
    });

    group('staticImageMode', () {
      test('true by default', () {
        expect(
          tf.EstimationConfig().staticImageMode,
          isTrue,
        );
      });
    });
  });
}
