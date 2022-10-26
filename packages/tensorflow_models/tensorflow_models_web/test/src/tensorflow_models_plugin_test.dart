import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as platform_interface;
import 'package:tensorflow_models_web/src/face_landmarks_detection/face_landmarks_detection.dart';
import 'package:tensorflow_models_web/tensorflow_models_web.dart';

class _MockFaceLandmarksDetectionInterop extends Mock
    implements FaceLandmarksDetectionInterop {}

class _MockFaceLandmarksDetector extends Mock implements FaceLandmarksDetector {
}

class _FakeModelConfig extends Fake implements ModelConfig {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeModelConfig());
  });

  group('TensorflowModelsPlugin', () {
    test('can be instantiated', () {
      expect(
        TensorflowModelsPlugin(),
        isA<TensorflowModelsPlugin>(),
      );
    });

    group('loadFaceLandmark', () {
      late FaceLandmarksDetectionInterop faceLandmarksDetectionInterop;
      setUp(() {
        faceLandmarksDetectionInterop = _MockFaceLandmarksDetectionInterop();
        FaceLandmarksDetectionInterop.instance = faceLandmarksDetectionInterop;
      });

      test('returns a FaceLandmarksDetector', () async {
        final subject = TensorflowModelsPlugin();
        final detector = _MockFaceLandmarksDetector();
        when(
          () => faceLandmarksDetectionInterop.createDetector(
            any<dynamic>(),
            any(),
          ),
        ).thenAnswer((_) async => detector);
        await expectLater(
          subject.loadFaceLandmark(),
          completion(isA<platform_interface.FaceLandmarksDetector>()),
        );
      });
    });
  });
}
