import 'dart:convert';
import 'dart:html' as html;
import 'dart:js_util';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image_loader/image_loader.dart';
import 'package:js_interop_utils/js_interop_utils.dart' as js_interop_utils;
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as platform_interface;

import 'package:tensorflow_models_web/src/face_landmarks_detection/interop/interop.dart';

/// Web implementation of [FaceLandmarksDetector].
///
/// See also:
/// * [MediaPipe's FaceMesh documentation](https://google.github.io/mediapipe/solutions/face_mesh.html)
/// * [Tensorflow's FaceLandmarkDetection source code](https://github.com/tensorflow/tfjs-models/tree/master/face-landmarks-detection)
class FaceLandmarksDetectorWeb
    implements platform_interface.FaceLandmarksDetector {
  FaceLandmarksDetectorWeb(this._faceLandmarksDetector);

  final FaceLandmarksDetector _faceLandmarksDetector;

  static FaceLandmarksDetectionInterop get interop =>
      FaceLandmarksDetectionInterop.instance;

  static Future<FaceLandmarksDetectorWeb> load([
    ModelConfig? config,
  ]) async {
    final detector = await interop.createDetector(
      'MediaPipeFaceMesh',
      config,
    );
    return FaceLandmarksDetectorWeb(detector);
  }

  /// Estimates [platform_interface.Faces] from different sources.
  ///
  /// The supported sources are:
  /// - [html.ImageElement] Raw html element that contains the image to process.
  /// - [String] A string that contains the url of the image to process.
  /// - [html.VideoElement] Raw html element that contains the image (last
  /// frame) to process.
  /// - [Uint8List] A list of bytes that contains the image to process.
  @override
  Future<platform_interface.Faces> estimateFaces(
    dynamic object, {
    platform_interface.EstimationConfig estimationConfig =
        const platform_interface.EstimationConfig(),
  }) async {
    final config = EstimationConfig(
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
    } else if (object is platform_interface.ImageData) {
      final imageData = html.ImageData(
        object.bytes.buffer.asUint8ClampedList(),
        object.size.width,
        object.size.height,
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

platform_interface.Faces _facesFromJs(List<dynamic> jsFaces) {
  final faces = <platform_interface.Face>[];
  for (final jsObject in jsFaces) {
    // Convert NativeJavascriptObject to Map by encoding and decoding JSON.
    final json = js_interop_utils.stringify(jsObject as Object);
    faces.add(
      platform_interface.Face.fromJson(
        jsonDecode(json) as Map<String, dynamic>,
      ),
    );
  }
  return faces;
}
