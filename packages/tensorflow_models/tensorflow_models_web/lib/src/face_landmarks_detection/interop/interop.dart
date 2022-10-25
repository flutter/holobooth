import 'dart:js_util';

import 'package:tensorflow_models_web/src/face_landmarks_detection/interop/generated/generated.dart'
    as interop;

export 'generated/common_interfaces.dart';
export 'generated/face_landmarks_detector.dart';
export 'generated/shape_interfaces.dart';
export 'generated/types.dart';

class FaceLandmarksDetectionInterop {
  FaceLandmarksDetectionInterop._();

  static FaceLandmarksDetectionInterop _instance =
      FaceLandmarksDetectionInterop._();

  static FaceLandmarksDetectionInterop get instance => _instance;

  static set instance(FaceLandmarksDetectionInterop value) {
    _instance = value;
  }

  Future<interop.FaceLandmarksDetector> createDetector(
    dynamic model, [
    interop.ModelConfig? config,
  ]) {
    return promiseToFuture(interop.createDetector(model, config));
  }
}
