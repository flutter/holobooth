@JS()
library base_model;

import 'package:js/js.dart';

/// @license
/// Copyright 2019 Google LLC. All Rights Reserved.
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
/// https://www.apache.org/licenses/LICENSE-2.0
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
/// ============================================================================
/// PoseNet supports using various convolution neural network models
/// (e.g. ResNet and MobileNetV1) as its underlying base model.
/// The following BaseModel interface defines a unified interface for
/// creating such PoseNet base models. Currently both MobileNet (in
/// ./mobilenet.ts) and ResNet (in ./resnet.ts) implements the BaseModel
/// interface. New base models that conform to the BaseModel interface can be
/// added to PoseNet.
@JS()
abstract class BaseModel {
  external factory BaseModel(
    dynamic model,
    String /*'32'|'16'|'8'*/ outputStride,
  );
  // @Ignore
  //BaseModel.fakeConstructor$();
  external dynamic get model;
  external String /*'32'|'16'|'8'*/ get outputStride;

  /// Releases the CPU and GPU memory allocated by the model.
  external void dispose();
}
