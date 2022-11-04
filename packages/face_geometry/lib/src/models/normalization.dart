import 'dart:collection';
import 'dart:math' as math;

import 'package:meta/meta.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;

/// Normalize faces keypoints and bounding box.
extension FacesNormalization on tf.Faces {
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

/// Normalize [tf.Keypoint] and [tf.BoundingBox] positions to another size.
extension FaceNormalization on tf.Face {
  /// Normalize [tf.Keypoint] and [tf.BoundingBox] positions to another size.
  tf.Face normalize({
    required tf.Size fromMax,
    required tf.Size toMax,
  }) {
    final keypoints = this.keypoints.map(
          (keypoint) => keypoint.normalize(fromMax: fromMax, toMax: toMax),
        );
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
