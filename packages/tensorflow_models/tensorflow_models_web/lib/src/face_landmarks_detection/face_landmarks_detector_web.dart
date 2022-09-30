import 'dart:convert';
import 'dart:html' as html;
import 'dart:js_util';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:image_loader/image_loader.dart';
import 'package:js_interop_utils/js_interop_utils.dart' as js_interop_utils;
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:tensorflow_models_web/src/face_landmarks_detection/interop/interop.dart'
    as interop;

/// Web implementation of [FaceLandmarksDetector].
///
/// See also:
/// * [MediaPipe's FaceMesh documentation](https://google.github.io/mediapipe/solutions/face_mesh.html)
/// * [Tensorflow's FaceLandmarkDetection source code](https://github.com/tensorflow/tfjs-models/tree/master/face-landmarks-detection)
class FaceLandmarksDetectorWeb implements FaceLandmarksDetector {
  FaceLandmarksDetectorWeb(this._faceLandmarksDetector);

  final interop.FaceLandmarksDetector _faceLandmarksDetector;

  static Future<FaceLandmarksDetectorWeb> load([
    interop.ModelConfig? config,
  ]) async =>
      FaceLandmarksDetectorWeb(
        await promiseToFuture(
          interop.createDetector('MediaPipeFaceMesh', config),
        ),
      );

  /// Estimates [Faces] from different sources.
  ///
  /// The supported sources are:
  /// - [html.ImageElement] Raw html element that contains the image to process.
  /// - [String] A string that contains the url of the image to process.
  /// - [html.VideoElement] Raw html element that contains the image (last
  /// frame) to process.
  /// - [Uint8List] A list of bytes that contains the image to process.
  @override
  Future<Faces> estimateFaces(
    dynamic object, {
    EstimationConfig estimationConfig = const EstimationConfig(),
  }) async {
    final config = interop.EstimationConfig(
      flipHorizontal: estimationConfig.flipHorizontal,
      staticImageMode: estimationConfig.staticImageMode,
    );

    if (object is html.VideoElement) {
      final result = await promiseToFuture<List<dynamic>>(
        _faceLandmarksDetector.estimateFaces(object, config),
      );
      return _facesFromJs(result);
    } else if (object is String) {
      final image = await HtmlImageLoader(object).loadImage();
      final result = await promiseToFuture<List<dynamic>>(
        _faceLandmarksDetector.estimateFaces(image.imageElement, config),
      );
      return _facesFromJs(result);
    } else if (object is html.ImageElement) {
      final result = await promiseToFuture<List<dynamic>>(
        _faceLandmarksDetector.estimateFaces(object, config),
      );
      return _facesFromJs(result);
    } else if (object is ImageData) {
      // FIXME(alestiago): When converting to an [html.ImageData]:
      // "DOMException: Failed to construct 'ImageData': The input data length
      // is not a multiple of 4."
      // const methodChannels = 4;
      // final pixels = object.width * object.height;
      // final bytes = Uint8ClampedList(pixels * methodChannels);
      // for (var pixel = 0; pixel < pixels; pixel++) {
      //   for (var channel = 0; channel < methodChannels; channel++) {
      //     bytes[pixel * methodChannels + channel] =
      //         object.data[pixel * methodChannels + channel];
      //   }
      // }
      final imageData = html.ImageData(
        Uint8ClampedList.fromList(object.data),
        object.width,
        object.height,
      );
      final result = await promiseToFuture<List<dynamic>>(
        _faceLandmarksDetector.estimateFaces(imageData, config),
      );
      return _facesFromJs(result);
    }

    throw Exception('Unsupported input type');
  }

  @override
  void dispose() => _faceLandmarksDetector.dispose();
}

Faces _facesFromJs(List<dynamic> jsFaces) {
  final faces = <Face>[];
  for (final jsObject in jsFaces) {
    // Convert NativeJavascriptObject to Map by encoding and decoding JSON.
    final json = js_interop_utils.stringify(jsObject as Object);
    faces.add(Face.fromJson(jsonDecode(json) as Map<String, dynamic>));
  }
  return faces;
}
