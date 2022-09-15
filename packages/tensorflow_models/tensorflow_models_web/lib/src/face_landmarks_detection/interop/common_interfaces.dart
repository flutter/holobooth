@JS()
library common_interfaces;

import "package:js/js.dart";

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
/*export declare type PixelInput = Tensor3D | ImageData | HTMLVideoElement | HTMLImageElement | HTMLCanvasElement | ImageBitmap;*/
@anonymous
@JS()
abstract class InputResolution {
  external num get width;
  external set width(num v);
  external num get height;
  external set height(num v);
  external factory InputResolution({num width, num height});
}

/// A keypoint that contains coordinate information.
@anonymous
@JS()
abstract class Keypoint {
  external num get x;
  external set x(num v);
  external num get y;
  external set y(num v);
  external num get z;
  external set z(num v);
  external num get score;
  external set score(num v);
  external String get name;
  external set name(String v);
  external factory Keypoint({num x, num y, num z, num score, String name});
}

@anonymous
@JS()
abstract class ImageSize {
  external num get height;
  external set height(num v);
  external num get width;
  external set width(num v);
  external factory ImageSize({num height, num width});
}

@anonymous
@JS()
abstract class Padding {
  external num get top;
  external set top(num v);
  external num get bottom;
  external set bottom(num v);
  external num get left;
  external set left(num v);
  external num get right;
  external set right(num v);
  external factory Padding({num top, num bottom, num left, num right});
}

@anonymous
@JS()
abstract class ValueTransform {
  external num get scale;
  external set scale(num v);
  external num get offset;
  external set offset(num v);
  external factory ValueTransform({num scale, num offset});
}

@anonymous
@JS()
abstract class WindowElement {
  external num get distance;
  external set distance(num v);
  external num get duration;
  external set duration(num v);
  external factory WindowElement({num distance, num duration});
}

@anonymous
@JS()
abstract class KeypointsFilter {
  external List<Keypoint> apply(
      List<Keypoint> landmarks, num microSeconds, num objectScale);
  external void reset();
}

@anonymous
@JS()
abstract class Mask {
  external String /*'canvasimagesource'|'imagedata'|'tensor'*/ getUnderlyingType();
}

@anonymous
@JS()
abstract class _Mask {
/*  external Promise<
          dynamic /*HTMLImageElement|SVGImageElement|HTMLVideoElement|HTMLCanvasElement|ImageBitmap|OffscreenCanvas*/ >
      toCanvasImageSource();
  external Promise<ImageData> toImageData();
  external Promise<Tensor3D> toTensor();*/
}

/*extension MaskExtensions on Mask {
  Future<dynamic /*HTMLImageElement|SVGImageElement|HTMLVideoElement|HTMLCanvasElement|ImageBitmap|OffscreenCanvas*/ >
      toCanvasImageSource() {
    final Object t = this;
    final _Mask tt = t;
    return promiseToFuture(tt.toCanvasImageSource());
  }

  Future<ImageData> toImageData() {
    final Object t = this;
    final _Mask tt = t;
    return promiseToFuture(tt.toImageData());
  }

  Future<Tensor3D> toTensor() {
    final Object t = this;
    final _Mask tt = t;
    return promiseToFuture(tt.toTensor());
  }
}*/

@anonymous
@JS()
abstract class Segmentation {
  external String Function(num) get maskValueToLabel;
  external set maskValueToLabel(String Function(num) v);
  external Mask get mask;
  external set mask(Mask v);
  external factory Segmentation(
      {String Function(num) maskValueToLabel, Mask mask});
}

@anonymous
@JS()
abstract class Color {
  external num get r;
  external set r(num v);
  external num get g;
  external set g(num v);
  external num get b;
  external set b(num v);
  external num get a;
  external set a(num v);
  external factory Color({num r, num g, num b, num a});
}

@JS()
abstract class Promise<T> {
  external factory Promise(
      void executor(void resolve(T result), Function reject));
  external Promise then(void onFulfilled(T result), [Function onRejected]);
}
