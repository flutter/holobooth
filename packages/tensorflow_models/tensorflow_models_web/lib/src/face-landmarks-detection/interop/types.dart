@JS()
library types;

import "package:js/js.dart";
import 'package:tensorflow_models_web/src/face-landmarks-detection/interop/common_interfaces.dart';

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
/// export { Keypoint };
@JS()
class SupportedModels {
  external static String get MediaPipeFaceMesh;
}

/// Common config to create the face detector.
/// `maxFaces`: Optional. Default to 1. The maximum number of faces that will
/// be detected by the model. The number of returned faces can be less than the
/// maximum (for example when no faces are present in the input).
@anonymous
@JS()
abstract class ModelConfig {
  external num get maxFaces;
  external set maxFaces(num v);
  external factory ModelConfig({num maxFaces});
}

/// Common config for the `estimateFaces` method.
/// `flipHorizontal`: Optional. Default to false. In some cases, the image is
/// mirrored, e.g. video stream from camera, flipHorizontal will flip the
/// keypoints horizontally.
/// `staticImageMode`: Optional. Default to true. If set to true, face detection
/// will run on every input image, otherwise if set to false then detection runs
/// once and then the model simply tracks those landmarks without invoking
/// another detection until it loses track of any of the faces (ideal for
/// videos).
@anonymous
@JS()
abstract class EstimationConfig {
  external bool get flipHorizontal;
  external set flipHorizontal(bool v);
  external bool get staticImageMode;
  external set staticImageMode(bool v);
  external factory EstimationConfig(
      {bool flipHorizontal, bool staticImageMode});
}

/// Allowed input format for the `estimateFaces` method.
/*export declare type FaceLandmarksDetectorInput = PixelInput;*/
@anonymous
@JS()
abstract class Face {
  external factory Face({List<Keypoint> keypoints, dynamic box});
  external List<Keypoint> get keypoints;
  external set keypoints(List<Keypoint> v);
}

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
/// Common MediaPipeFaceMesh model config.
@anonymous
@JS()
abstract class MediaPipeFaceMeshModelConfig implements ModelConfig {
  external String /*'mediapipe'|'tfjs'*/ get runtime;
  external set runtime(String /*'mediapipe'|'tfjs'*/ v);
  external bool get refineLandmarks;
  external set refineLandmarks(bool v);
  external factory MediaPipeFaceMeshModelConfig(
      {String /*'mediapipe'|'tfjs'*/ runtime,
      bool refineLandmarks,
      num maxFaces});
}

@anonymous
@JS()
abstract class MediaPipeFaceMeshEstimationConfig implements EstimationConfig {
  external factory MediaPipeFaceMeshEstimationConfig(
      {bool flipHorizontal, bool staticImageMode});
}

/// Model parameters for MediaPipeFaceMesh MediaPipe runtime
/// `runtime`: Must set to be 'mediapipe'.
/// `refineLandmarks`: If set to true, refines the landmark coordinates around
/// the eyes and lips, and output additional landmarks around the irises.
/// `solutionPath`: Optional. The path to where the wasm binary and model files
/// are located.
@anonymous
@JS()
abstract class MediaPipeFaceMeshMediaPipeModelConfig
    implements MediaPipeFaceMeshModelConfig {
  external String /*'mediapipe'*/ get runtime;
  external set runtime(String /*'mediapipe'*/ v);
  external String get solutionPath;
  external set solutionPath(String v);
  external factory MediaPipeFaceMeshMediaPipeModelConfig(
      {String /*'mediapipe'*/ runtime,
      String solutionPath,
      bool refineLandmarks,
      num maxFaces});
}

/// Face estimation parameters for MediaPipeFaceMesh MediaPipe runtime.
@anonymous
@JS()
abstract class MediaPipeFaceMeshMediaPipeEstimationConfig
    implements MediaPipeFaceMeshEstimationConfig {
  external factory MediaPipeFaceMeshMediaPipeEstimationConfig(
      {bool flipHorizontal, bool staticImageMode});
}
