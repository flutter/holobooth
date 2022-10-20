import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:test/test.dart';

class _TestFaceLandmarkDetector extends FaceLandmarksDetector {
  @override
  void dispose() {}

  @override
  Future<Faces> estimateFaces(
    dynamic object, {
    EstimationConfig estimationConfig = const EstimationConfig(),
  }) =>
      throw UnimplementedError();
}

void main() {
  group('FaceLandmarkDetector', () {
    test('can be instantiated', () {
      expect(
        _TestFaceLandmarkDetector(),
        isA<FaceLandmarksDetector>(),
      );
    });
  });
}
