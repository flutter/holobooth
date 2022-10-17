import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;

class _TestFaceLandmarkDetector extends tf.FaceLandmarksDetector {
  @override
  void dispose() {}

  @override
  Future<tf.Faces> estimateFaces(
    dynamic object, {
    tf.EstimationConfig estimationConfig = const tf.EstimationConfig(),
  }) =>
      throw UnimplementedError();
}

void main() {
  group('FaceLandmarkDetector', () {
    test('can be instantiated', () {
      expect(
        _TestFaceLandmarkDetector(),
        isA<tf.FaceLandmarksDetector>(),
      );
    });
  });
}
