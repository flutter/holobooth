@TestOn('chrome')
import 'dart:html';
import 'dart:js';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models_web/src/face_landmarks_detection/face_landmarks_detection.dart';
import 'package:tensorflow_models_web/tensorflow_models_web.dart';

class _MockFaceLandmark extends Mock implements FaceLandmarksDetectorJs {}

class _MockDetector extends Mock implements FaceLandmarksDetector {}

abstract class FaceLandmarksDetectorJs {
  Future<FaceLandmarksDetector> createDetector(
    dynamic model, [
    ModelConfig? config,
  ]);
}

void main() {
  group('TensorflowModelsPlugin', () {
    test('can be instantiated', () {
      expect(
        TensorflowModelsPlugin(),
        isA<TensorflowModelsPlugin>(),
      );
    });

    group('loadFaceLandmark', () {
      late FaceLandmarksDetectorJs faceLandmarksDetectorJs;
      setUp(() {
        faceLandmarksDetectorJs = _MockFaceLandmark();
      });

      test('returns a FaceLandmarkDetector', () async {
        final subject = TensorflowModelsPlugin();
        context.
        (window as dynamic).faceLandmarksDetection = faceLandmarksDetectorJs;
        when(() => faceLandmarksDetectorJs.createDetector(any()))
            .thenAnswer((invocation) async => _MockDetector());
        await expectLater(
          subject.loadFaceLandmark(),
          isA<FaceLandmarksDetector>(),
        );
      });
    });
  });
}
