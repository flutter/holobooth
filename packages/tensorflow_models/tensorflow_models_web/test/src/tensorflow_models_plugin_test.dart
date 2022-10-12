@TestOn('chrome')
import 'package:flutter_test/flutter_test.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:tensorflow_models_web/tensorflow_models_web.dart';

void main() {
  group('TensorflowModelsPlugin', () {
    test('can be instantiated', () {
      expect(
        TensorflowModelsPlugin(),
        isA<TensorflowModelsPlugin>(),
      );
    });

    group('loadFaceLandmark', () {
      test('returns a FaceLandmarkDetector', () async {
        final subject = TensorflowModelsPlugin();
        await expectLater(
          subject.loadFaceLandmark(),
          isA<FaceLandmarksDetector>(),
        );
      });
    });
  });
}
