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

  PoseNetWeb._(this._net);

  final interop.PoseNet _net;

  /// Returns a pose estimation for an ImageData
  @override
  Future<Pose> estimateSinglePose(
    String path, {
    SinglePersonInterfaceConfig? config,
  }) async {
    final image = await HtmlImageLoader(path).loadImage();
    final pose = await promiseToFuture<interop.Pose>(
      _net.estimateSinglePose(image.imageElement, config?.toJs()),
    );
    return pose.fromJs();
  }

  /// Returns a pose estimation for an ImageData
  @override
  Future<Pose> estimateSinglePoseFromVideoElement({
    SinglePersonInterfaceConfig? config,
  }) async {
    final videoElement = html.querySelector('video');
    final pose = await promiseToFuture<interop.Pose>(
      _net.estimateSinglePose(videoElement, config?.toJs()),
    );
    return pose.fromJs();
  }

  @override
  void dispose() => _net.dispose();
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
