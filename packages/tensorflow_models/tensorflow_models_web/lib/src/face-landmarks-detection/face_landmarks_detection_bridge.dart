import 'dart:html' as html;
import 'dart:js_util';

import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:tensorflow_models_web/src/face-landmarks-detection/interop/interop.dart'
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

class FaceLandmarksDetectorWeb implements FaceLandmarksDetector {
  factory FaceLandmarksDetectorWeb.fromJs(interop.FaceLandmarksDetector net) {
    return FaceLandmarksDetectorWeb._(net);
  }
  FaceLandmarksDetectorWeb._(this._net);
  final interop.FaceLandmarksDetector _net;

  /// Returns faces
  @override
  Future<List<Face>> estimateFaces() async {
    final videoElement = html.querySelector('video') as html.VideoElement?;
    videoElement?.setAttribute('height', 1200);
    videoElement?.setAttribute('width', 850);
    final config =
        interop.EstimationConfig(flipHorizontal: true, staticImageMode: false);
    final faces = await promiseToFuture<dynamic>(
      _net.estimateFaces(videoElement, config),
    );
    return [];
    //return faces.map((e) => e.fromJs()).toList();
  }

  @override
  void dispose() => _net.dispose();
}

extension on interop.Face {
  Face fromJs() {
    return Face(
      keypoints.map((k) => k.fromJs()).toList(),
    );
  }
}

extension on interop.Keypoint {
  Keypoint fromJs() {
    return Keypoint(x, y, z, score, name);
  }
}
