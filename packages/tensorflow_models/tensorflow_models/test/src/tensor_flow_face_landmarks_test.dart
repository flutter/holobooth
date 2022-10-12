import 'package:flutter_test/flutter_test.dart';
import 'package:tensorflow_models/tensorflow_models.dart';

class FakeTensorFlowFaceLandmarks extends Fake
    implements TensorFlowFaceLandmarks {}

void main() {
  group('TensorFlowFaceLandmarks', () {
    test('can be instantiated', () {
      final fakeFaceLandmarks = FakeTensorFlowFaceLandmarks();
      expect(fakeFaceLandmarks, isNotNull);
    });

    test('throws an UnimplementedError', () {
      expect(
        TensorFlowFaceLandmarks.load,
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}
