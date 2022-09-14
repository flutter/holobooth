@JS('posenet')
library posenet;

import 'package:js/js.dart';
import 'package:tensorflow_models_web/src/posenet/interop/base_model.dart'
    show BaseModel;
import 'package:tensorflow_models_web/src/posenet/interop/types.dart' show Pose;

@JS()
external Promise<PoseNet> load([ModelConfig? config]);

/// @license
/// Copyright 2019 Google LLC. All Rights Reserved.
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
/// http://www.apache.org/licenses/LICENSE-2.0
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
/// =============================================================================
/// PoseNet model loading is configurable using the following config dictionary.
/// `architecture`: PoseNetArchitecture. It determines wich PoseNet architecture
/// to load. The supported architectures are: MobileNetV1 and ResNet.
/// `outputStride`: Specifies the output stride of the PoseNet model.
/// The smaller the value, the larger the output resolution, and more accurate
/// the model at the cost of speed.  Set this to a larger value to increase speed
/// at the cost of accuracy. Stride 32 is supported for ResNet and
/// stride 8,16,32 are supported for various MobileNetV1 models.
/// * `inputResolution`: A number or an Object of type {width: number, height:
/// number}. Specifies the size the input image is scaled to before feeding it
/// through the PoseNet model.  The larger the value, more accurate the model at
/// the cost of speed. Set this to a smaller value to increase speed at the cost
/// of accuracy. If a number is provided, the input will be resized and padded to
/// be a square with the same width and height.  If width and height are
/// provided, the input will be resized and padded to the specified width and
/// height.
/// `multiplier`: An optional number with values: 1.01, 1.0, 0.75, or
/// 0.50. The value is used only by MobileNet architecture. It is the float
/// multiplier for the depth (number of channels) for all convolution ops.
/// The larger the value, the larger the size of the layers, and more accurate
/// the model at the cost of speed. Set this to a smaller value to increase speed
/// at the cost of accuracy.
/// `modelUrl`: An optional string that specifies custom url of the model. This
/// is useful for area/countries that don't have access to the model hosted on
/// GCP.
/// `quantBytes`: An opional number with values: 1, 2, or 4.  This parameter
/// affects weight quantization in the models. The available options are
/// 1 byte, 2 bytes, and 4 bytes. The higher the value, the larger the model size
/// and thus the longer the loading time, the lower the value, the shorter the
/// loading time but lower the accuracy.
@anonymous
@JS()
abstract class ModelConfig {
  external factory ModelConfig({
    String? architecture,
    int? outputStride,
    dynamic inputResolution,
    double? multiplier,
    int? quantBytes,
  });
}

/// PoseNet inference is configurable using the following config dictionary.
/// `flipHorizontal`: If the poses should be flipped/mirrored horizontally.
/// This should be set to true for videos where the video is by default flipped
/// horizontally (i.e. a webcam), and you want the poses to be returned in the
/// proper orientation.
@anonymous
@JS()
abstract class InferenceConfig {
  external bool get flipHorizontal;
  external set flipHorizontal(bool v);
  external factory InferenceConfig({bool flipHorizontal});
}

/// Single Person Inference Config
@anonymous
@JS()
abstract class SinglePersonInterfaceConfig implements InferenceConfig {
  external factory SinglePersonInterfaceConfig({bool? flipHorizontal});
}

/// Multiple Person Inference Config
/// `maxDetections`: Maximum number of returned instance detections per image.
/// `scoreThreshold`: Only return instance detections that have root part
/// score greater or equal to this value. Defaults to 0.5
/// `nmsRadius`: Non-maximum suppression part distance in pixels. It needs
/// to be strictly positive. Two parts suppress each other if they are less
/// than `nmsRadius` pixels away. Defaults to 20.
@anonymous
@JS()
abstract class MultiPersonInferenceConfig implements InferenceConfig {
  external num get maxDetections;
  external set maxDetections(num v);
  external num get scoreThreshold;
  external set scoreThreshold(num v);
  external num get nmsRadius;
  external set nmsRadius(num v);
  external factory MultiPersonInferenceConfig(
      {num maxDetections,
      num scoreThreshold,
      num nmsRadius,
      bool flipHorizontal});
}

@anonymous
@JS()
abstract class LegacyMultiPersonInferenceConfig
    implements MultiPersonInferenceConfig {
  external String /*'multi-person'*/ get decodingMethod;
  external set decodingMethod(String /*'multi-person'*/ v);
  external factory LegacyMultiPersonInferenceConfig(
      {String /*'multi-person'*/ decodingMethod,
      num maxDetections,
      num scoreThreshold,
      num nmsRadius,
      bool flipHorizontal});
}

@anonymous
@JS()
abstract class LegacySinglePersonInferenceConfig
    implements SinglePersonInterfaceConfig {
  external String /*'single-person'*/ get decodingMethod;
  external set decodingMethod(String /*'single-person'*/ v);
  external factory LegacySinglePersonInferenceConfig(
      {String /*'single-person'*/ decodingMethod, bool flipHorizontal});
}

@JS()
external SinglePersonInterfaceConfig get SINGLE_PERSON_INFERENCE_CONFIG;
@JS()
external MultiPersonInferenceConfig get MULTI_PERSON_INFERENCE_CONFIG;

@JS('PoseNet')
class PoseNet {
  // @Ignore
  //PoseNet.fakeConstructor$();
  external BaseModel get baseModel;
  external List<num> /*Tuple of <num,num>*/ get inputResolution;
  external factory PoseNet(
      BaseModel net, List<num> /*Tuple of <num,num>*/ inputResolution);
  external void dispose();

  /// Infer through PoseNet, and estimates a single pose using the outputs.
  /// This does standard ImageNet pre-processing before inferring through the
  /// model. The image should pixels should have values [0-255]. It detects
  /// multiple poses and finds their parts from part scores and displacement
  /// vectors using a fast greedy decoding algorithm.  It returns a single pose
  /// ImageData|HTMLImageElement|HTMLCanvasElement|HTMLVideoElement) The input
  /// image to feed through the network.
  /// parameters for the PoseNet inference using single pose estimation.
  /// the corresponding keypoint scores.  The positions of the keypoints are
  /// in the same scale as the original image
  external Promise<Pose> estimateSinglePose(
      dynamic /*ImageData|HTMLImageElement|HTMLCanvasElement|HTMLVideoElement|tf.Tensor3D*/ input,
      [SinglePersonInterfaceConfig? config]);
}

@JS()
abstract class Promise<T> {
  external factory Promise(
      void executor(void resolve(T result), Function reject));
  external Promise then(void onFulfilled(T result), [Function onRejected]);
}
