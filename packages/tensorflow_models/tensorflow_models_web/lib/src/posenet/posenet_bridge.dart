import 'dart:async';
import 'dart:html' as html;
import 'dart:js_util';

import 'package:image_loader/image_loader.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:tensorflow_models_web/src/posenet/interop/interop.dart'
    as interop;

Future<PoseNetWeb> load([interop.ModelConfig? config]) async {
  return PoseNetWeb.fromJs(await promiseToFuture(interop.load(config)));
}

class PoseNetWeb implements PoseNet {
  factory PoseNetWeb.fromJs(interop.PoseNet net) {
    return PoseNetWeb._(net);
  }

  PoseNetWeb._(this._poseNet);

  final interop.PoseNet _poseNet;

  /// Returns a pose estimation from data.
  ///
  /// The data can be:
  /// - [String] a path to an image.
  /// - [html.VideoElement] a video element, where the latest frame is used.
  @override
  Future<Pose> estimateSinglePose(
    dynamic data, {
    SinglePersonInterfaceConfig? config,
  }) async {
    if (data is String) {
      final image = await HtmlImageLoader(data).loadImage();
      final pose = await promiseToFuture<interop.Pose>(
        _poseNet.estimateSinglePose(image.imageElement, config?.toJs()),
      );
      return pose.fromJs();
    } else if (data is html.VideoElement) {
      final pose = await promiseToFuture<interop.Pose>(
        _poseNet.estimateSinglePose(data, config?.toJs()),
      );
      return pose.fromJs();
    }

    throw UnimplementedError('Does not support $data');
  }

  @override
  void dispose() => _poseNet.dispose();
}

extension on SinglePersonInterfaceConfig {
  interop.SinglePersonInterfaceConfig toJs() {
    return interop.SinglePersonInterfaceConfig(flipHorizontal: flipHorizontal);
  }
}

extension on ImageData {
  // ignore: unused_element
  html.ImageData toJs() => html.ImageData(data, width, height);
}

extension on interop.Pose {
  Pose fromJs() {
    return Pose(
      keypoints: keypoints.map((k) => k.fromJs()).toList(),
      score: score,
    );
  }
}

extension on interop.Keypoint {
  Keypoint fromJs() {
    return Keypoint(score: score, position: position.fromJs(), part: part);
  }
}

extension on interop.Vector2D {
  Vector2D fromJs() => Vector2D(x: x, y: y);
}
