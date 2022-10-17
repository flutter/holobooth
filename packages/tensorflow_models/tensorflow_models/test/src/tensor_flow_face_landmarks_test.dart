import 'package:flutter_test/flutter_test.dart';
import 'package:tensorflow_models/tensorflow_models.dart';

class _TestTensorFlowFaceLandmarks extends TensorFlowFaceLandmarks {}

void main() {
  group('TensorFlowFaceLandmarks', () {
    test('can be instantiated', () {
      expect(
        _TestTensorFlowFaceLandmarks(),
        isA<TensorFlowFaceLandmarks>(),
      );
    });

    group('load', () {
      test('throws an UnimplementedError', () {
        expect(
          TensorFlowFaceLandmarks.load,
          throwsA(isA<UnimplementedError>()),
        );
      });
    });
  });
}
