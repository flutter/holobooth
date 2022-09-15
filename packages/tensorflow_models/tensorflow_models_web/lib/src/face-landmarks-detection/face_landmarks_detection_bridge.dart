import 'dart:js_util';

import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:tensorflow_models_web/src/face-landmarks-detection/interop/interop.dart'
    as interop;

Future<FaceLandmarksDetectorWeb> createDetector([
  interop.ModelConfig? config,
]) async {
  return FaceLandmarksDetectorWeb.fromJs(
    await promiseToFuture(
      interop.createDetector('MediaPipeFaceMesh', config),
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
  Future<List<Face>> estimateFaces(dynamic input) async {
    final faces = await promiseToFuture<List<interop.Face>>(
      _net.estimateFaces(input),
    );
    return faces.map((e) => e.fromJs()).toList();
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
