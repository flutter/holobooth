import 'dart:collection';
import 'dart:math' as math;

import 'package:meta/meta.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

/// Normalize [Keypoint] and [BoundingBox] positions to another size.
extension FaceNormalization on Face {
  /// Normalize [Keypoint] and [BoundingBox] positions to another size.
  Face normalize({
    required Size fromMax,
    required Size toMax,
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
/// Normalize a [BoundingBox].
///
/// The normalized values are
/// [BoundingBox.height], [BoundingBox.width], [BoundingBox.xMax],
/// [BoundingBox.xMin], [BoundingBox.yMax] and [BoundingBox.yMin].
///
/// See also:
///
/// * [NormalizeNum], equation to normalize numeric values.
/// {@endtemplate}
@visibleForTesting
extension NormalizeBoundingBox on BoundingBox {
  /// {@macro normalize_bounding_box}
  BoundingBox normalize({
    required Size fromMax,
    required Size toMax,
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
/// Normalize a [Keypoint].
///
/// The normalized values are [Keypoint.x] and [Keypoint.y].
///
/// See also:
///
/// * [NormalizeNum], equation to normalize numeric values.
/// {@endtemplate}
@visibleForTesting
extension NormalizeKeypoint on Keypoint {
  /// The distance between this and other [Keypoint].
  double distanceTo(Keypoint other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return math.sqrt(math.pow(dx, 2) + math.pow(dy, 2));
  }

  /// {@macro normalize_keypoint}
  Keypoint normalize({
    required Size fromMax,
    required Size toMax,
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
