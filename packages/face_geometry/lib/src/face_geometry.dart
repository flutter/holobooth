import 'dart:collection';
import 'dart:math' as math;

import 'package:face_geometry/face_geometry.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;

/// Normalize faces keypoints and bounding box.
extension FacesGeometry on tf.Faces {
  /// Normalize key points and bounding box from size to size.
  tf.Faces normalize({
    required TFSize fromMax,
    required TFSize toMax,
  }) {
    final newFaces =
        map((face) => face.normalize(fromMax: fromMax, toMax: toMax));
    return newFaces.toList();
  }
}

/// Set of calculations to detect common face expressions.
extension FaceGeometry on tf.Face {
  /// The distance between the top lip and the bottom lip.
  double get mouthDistance {
    if (keypoints.length < 15) return 0;
    final topLipPoint = keypoints[13];
    final bottomLipPoint = keypoints[14];
    return topLipPoint.distanceTo(bottomLipPoint);
  }

  /// The distance between the top left eye lid and the bottom left eye lid.
  double get leftEyeDistance {
    if (keypoints.length < 160) return 0;
    final topEyeLid = keypoints[159];
    final bottomEyeLid = keypoints[145];
    return topEyeLid.distanceTo(bottomEyeLid);
  }

  /// The distance between the top right eye lid and the bottom right eye lid
  double get rightEyeDistance {
    if (keypoints.length < 387) return 0;
    final topEyeLid = keypoints[386];
    final bottomEyeLid = keypoints[374];
    return topEyeLid.distanceTo(bottomEyeLid);
  }

  /// Normalize key points and bounding box from size to size.
  tf.Face normalize({
    required TFSize fromMax,
    required TFSize toMax,
  }) {
    final keypoints = this
        .keypoints
        .map((keypoint) => keypoint.normalize(fromMax: fromMax, toMax: toMax))
        .toList();
    final boundingBox = this.boundingBox.normalize(
          fromMax: fromMax,
          toMax: toMax,
        );
    return copyWith(
      keypoints: UnmodifiableListView(keypoints),
      boundingBox: boundingBox,
    );
  }
}

/// {@template normalize_bounding_box}
/// Normalize the BoundingBox.
/// {@endtemplate}
extension NormalizeBoundingBox on tf.BoundingBox {
  /// {@macro normalize_bounding_box}
  tf.BoundingBox normalize({
    required TFSize fromMax,
    required TFSize toMax,
  }) {
    return copyWith(
      height: height.normalize(fromMax: fromMax.height, toMax: toMax.height),
      width: width.normalize(fromMax: fromMax.width, toMax: toMax.width),
      xMax: xMax.normalize(fromMax: fromMax.width, toMax: toMax.width),
      xMin: xMin.normalize(fromMax: fromMax.width, toMax: toMax.width),
      yMax: yMax.normalize(fromMax: fromMax.height, toMax: toMax.height),
      yMin: yMin.normalize(fromMax: fromMax.height, toMax: toMax.height),
    );
  }
}

/// {@template normalize_keypoint}
/// Normalize keypoint.
/// {@endtemplate}
extension NormalizeKeypoint on tf.Keypoint {
  /// The distance between this and other keypoint.
  double distanceTo(tf.Keypoint other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return math.sqrt(math.pow(dx, 2) + math.pow(dy, 2));
  }

  /// {@macro normalize_keypoint}
  tf.Keypoint normalize({
    required TFSize fromMax,
    required TFSize toMax,
  }) {
    return copyWith(
      x: x.normalize(fromMax: fromMax.width, toMax: toMax.width),
      y: y.normalize(fromMax: fromMax.height, toMax: toMax.height),
    );
  }
}

/// {@template normalize_number}
/// Normalize number.
/// {@endtemplate}
extension NormalizeNum on num {
  /// {@macro normalize_number}
  double normalize({
    num fromMin = 0,
    required num fromMax,
    num toMin = 0,
    required num toMax,
  }) {
    assert(fromMin < fromMax, 'fromMin must be less than fromMax');
    assert(toMin < toMax, 'toMin must be less than toMax');

    return (toMax - toMin) * ((this - fromMin) / (fromMax - fromMin)) + toMin;
  }
}
