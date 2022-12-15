import 'dart:convert';
import 'dart:html' as html;
import 'dart:js_util';

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

  /// Estimates [platform_interface.Faces] from an image.
  @override
  Future<platform_interface.Faces> estimateFaces(
    platform_interface.ImageData imageData, {
    platform_interface.EstimationConfig estimationConfig =
        const platform_interface.EstimationConfig(),
  }) async {
    final config = EstimationConfig(
      flipHorizontal: estimationConfig.flipHorizontal,
      staticImageMode: estimationConfig.staticImageMode,
    );

    final htmlImageData = html.ImageData(
      imageData.bytes.buffer.asUint8ClampedList(),
      imageData.size.width,
      imageData.size.height,
    );
    final result = await promiseToFuture<List<dynamic>>(
      _faceLandmarksDetector.estimateFaces(htmlImageData, config),
    );
    return _facesFromJs(result);
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
