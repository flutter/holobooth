import 'dart:html' as html;
import 'dart:js_util';

import 'package:image_loader/image_loader.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:tensorflow_models_web/src/face_landmarks_detection/interop/interop.dart'
    as interop;

Future<FaceLandmarksDetectorWeb> createDetector([
  interop.ModelConfig? config,
]) async {
  return FaceLandmarksDetectorWeb.fromJs(
    await promiseToFuture(
      interop.createDetector(
        'MediaPipeFaceMesh',
        config,
      ),
    ),
  );
}

/// Web implementation of [FaceLandmarksDetector].
///
/// See also:
/// * [MediaPipe's FaceMesh documentation](https://google.github.io/mediapipe/solutions/face_mesh.html)
/// * [Tensorflow's FaceLandmarkDetection source code](https://github.com/tensorflow/tfjs-models/tree/master/face-landmarks-detection)
class FaceLandmarksDetectorWeb implements FaceLandmarksDetector {
  factory FaceLandmarksDetectorWeb.fromJs(
    interop.FaceLandmarksDetector faceLandmarksDetector,
  ) {
    return FaceLandmarksDetectorWeb._(faceLandmarksDetector);
  }

  FaceLandmarksDetectorWeb._(this._faceLandmarksDetector);

  final interop.FaceLandmarksDetector _faceLandmarksDetector;

  /// Estimates [Faces] from an different sources.
  ///
  /// The supported sources are:
  /// - [html.ImageElement] Raw html element that contains the image to process.
  /// - [String] A string that contains the url of the image to process.
  /// - [html.VideoElement] Raw html element that contains the image (last
  /// frame) to process.
  @override
  Future<Faces> estimateFaces(dynamic object) async {
    final config = interop.EstimationConfig(
      flipHorizontal: true,
      staticImageMode: false,
    );

    if (object is html.VideoElement) {
      return promiseToFuture<Faces>(
        _faceLandmarksDetector.estimateFaces(object, config),
      );
    } else if (object is String) {
      final image = await HtmlImageLoader(object).loadImage();
      return promiseToFuture<Faces>(
        _faceLandmarksDetector.estimateFaces(image.imageElement, config),
      );
    } else if (object is html.ImageElement) {
      return promiseToFuture<Faces>(
        _faceLandmarksDetector.estimateFaces(object, config),
      );
    }

    throw Exception('Unsupported input type');
  }

  @override
  void dispose() => _faceLandmarksDetector.dispose();
}
