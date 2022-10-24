import 'dart:collection';
import 'dart:math' as math;

import 'package:face_geometry/face_geometry.dart';
import 'package:meta/meta.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;

final _leftEye = FaceEye();
final _rightEye = FaceEye();

/// An eyeballed estimated minimum mouth to face ratio.
///
/// This represents the minimum height of the mouth in comparison to the face
/// height.
const _minMouthFaceRatio = 0.02;

/// Normalize faces keypoints and bounding box.
@visibleForTesting
extension FacesGeometry on tf.Faces {
  /// Normalize [tf.Keypoint] and [tf.BoundingBox] positions to another size.
  tf.Faces normalize({
    required tf.Size fromMax,
    required tf.Size toMax,
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

  /// Detect if the left eye is closed.
  ///
  /// Detection works after the first blink to make sure we have the correct
  /// minimum and maximum values.
  bool get isLeftEyeClose => _leftEye.isClose(
        eyeDistance: leftEyeDistance,
        boundingBoxHeight: boundingBox.height.toDouble(),
      );

  /// Detect if the right eye is closed.
  ///
  /// Detection works after the first blink to make sure we have the correct
  /// minimum and maximum values.
  bool get isRightEyeClose => _rightEye.isClose(
        eyeDistance: rightEyeDistance,
        boundingBoxHeight: boundingBox.height.toDouble(),
      );

  /// Defines if the mouth is open based on hight and face height.
  bool get isMouthOpen {
    if (mouthDistance > 1) {
      if (boundingBox.height == 0) return false;
      final heightRatio = mouthDistance / boundingBox.height;
      if (heightRatio == 0) return false;

      return heightRatio > _minMouthFaceRatio;
    }

    return false;
  }

  /// Normalize [tf.Keypoint] and [tf.BoundingBox] positions to another size.
  tf.Face normalize({
    required tf.Size fromMax,
    required tf.Size toMax,
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
/// Normalize a [tf.BoundingBox].
///
/// The normalized values are
/// [tf.BoundingBox.height], [tf.BoundingBox.width], [tf.BoundingBox.xMax],
/// [tf.BoundingBox.xMin], [tf.BoundingBox.yMax] and [tf.BoundingBox.yMin].
///
/// See also:
///
/// * [NormalizeNum], equation to normalize numeric values.
/// {@endtemplate}
@visibleForTesting
extension NormalizeBoundingBox on tf.BoundingBox {
  /// {@macro normalize_bounding_box}
  tf.BoundingBox normalize({
    required tf.Size fromMax,
    required tf.Size toMax,
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
/// Normalize a [tf.Keypoint].
///
/// The normalized values are [tf.Keypoint.x] and [tf.Keypoint.y].
///
/// See also:
///
/// * [NormalizeNum], equation to normalize numeric values.
/// {@endtemplate}
@visibleForTesting
extension NormalizeKeypoint on tf.Keypoint {
  /// The distance between this and other [tf.Keypoint].
  double distanceTo(tf.Keypoint other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return math.sqrt(math.pow(dx, 2) + math.pow(dy, 2));
  }

  /// {@macro normalize_keypoint}
  tf.Keypoint normalize({
    required tf.Size fromMax,
    required tf.Size toMax,
  }) {
    return copyWith(
      x: x.normalize(fromMax: fromMax.width, toMax: toMax.width),
      y: y.normalize(fromMax: fromMax.height, toMax: toMax.height),
    );
  }
}

/// {@template normalize_number}
/// Normalize the value by getting the ratio from the current size `fromMax`
/// and applying it to the new size `toMax`.
/// {@endtemplate}
@visibleForTesting
extension NormalizeNum on num {
  /// {@macro normalize_number}
  double normalize({
    required num fromMax,
    required num toMax,
  }) {
    assert(fromMax > 0, 'fromMax must be greater than 0');
    return toMax * ((this) / fromMax);
  }
}
