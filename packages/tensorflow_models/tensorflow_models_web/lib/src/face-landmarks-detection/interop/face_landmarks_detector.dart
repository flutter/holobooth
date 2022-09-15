@JS('face-landmarks-detection')
library face_landmarks_detector;

import "package:js/js.dart";
import 'package:tensorflow_models_web/src/common/common.dart';

//import "mediapipe/types.dart" show MediaPipeFaceMeshMediaPipeEstimationConfig;
//import "tfjs/types.dart" show MediaPipeFaceMeshTfjsEstimationConfig;
import "types.dart" show Face, ModelConfig, SupportedModels;

@JS()
external Promise<FaceLandmarksDetector> createDetector(dynamic model);

/// @license
/// Copyright 2021 Google LLC. All Rights Reserved.
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
/// https://www.apache.org/licenses/LICENSE-2.0
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
/// =============================================================================
/// User-facing interface for all face pose detectors.
@anonymous
@JS()
abstract class FaceLandmarksDetector {
  /// Dispose the underlying models from memory.
  external void dispose();

  /// Reset global states in the model.
  external void reset();

  external Promise<List<Face>> estimateFaces(
      dynamic /*Tensor3D|ImageData|HTMLVideoElement|HTMLImageElement|HTMLCanvasElement|ImageBitmap*/ input,
      [dynamic /*MediaPipeFaceMeshMediaPipeEstimationConfig|MediaPipeFaceMeshTfjsEstimationConfig*/ estimationConfig]);
}
