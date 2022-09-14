@JS()
library types;

import 'package:js/js.dart';

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
/// ============================================================================

@anonymous
@JS()
abstract class Vector2D {
  external factory Vector2D({num y, num x});
  external num get y;
  external set y(num v);
  external num get x;
  external set x(num v);
}

@anonymous
@JS()
abstract class Part {
  external factory Part({num heatmapX, num heatmapY, num id});
  external num get heatmapX;
  external set heatmapX(num v);
  external num get heatmapY;
  external set heatmapY(num v);
  external num get id;
  external set id(num v);
}

@anonymous
@JS()
abstract class PartWithScore {
  external factory PartWithScore({num score, Part part});
  external num get score;
  external set score(num v);
  external Part get part;
  external set part(Part v);
}

@anonymous
@JS()
abstract class Keypoint {
  external factory Keypoint({num score, Vector2D position, String part});
  external num get score;
  external set score(num v);
  external Vector2D get position;
  external set position(Vector2D v);
  external String get part;
  external set part(String v);
}

@anonymous
@JS()
abstract class Pose {
  external factory Pose({List<Keypoint> keypoints, num score});
  external List<Keypoint> get keypoints;
  external set keypoints(List<Keypoint> v);
  external num get score;
  external set score(num v);
}

/*export declare type PosenetInput = ImageData | HTMLImageElement |
 HTMLCanvasElement | HTMLVideoElement | tf.Tensor3D;*/
/*export declare type TensorBuffer3D = tf.TensorBuffer<tf.Rank.R3>;*/
@anonymous
@JS()
abstract class Padding {
  external factory Padding({num top, num bottom, num left, num right});
  external num get top;
  external set top(num v);
  external num get bottom;
  external set bottom(num v);
  external num get left;
  external set left(num v);
  external num get right;
  external set right(num v);
}

/*export declare type InputResolution = number | {
    width: number;
    height: number;
};
*/
