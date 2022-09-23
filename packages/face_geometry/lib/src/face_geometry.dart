import 'dart:math' as math;

import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;

/// Set of calculations to detect common face expressions.
extension FaceGeometry on tf.Face {
  /// The distance between the top lip and the bottom lip in proportion to the
  /// face height.
  ///
  /// The value is always number between 0 and 1, representing the percentage of
  /// the mouth height in relation to the face height.
  double get mouthDistance {
    final topLipPoint = keypoints[13];
    final bottomLipPoint = keypoints[14];
    final verticalDistance = topLipPoint.distanceTo(bottomLipPoint);

    final topForehead = keypoints[10];
    final bottomChin = keypoints[152];
    // TODO(alestiago): Get the height from bounding box.
    final faceHeight = topForehead.distanceTo(bottomChin);

    return verticalDistance / faceHeight;
  }
}

extension on tf.Keypoint {
  double distanceTo(tf.Keypoint other) {
    final dx = x - other.x;
    final dy = y - other.y;
    final dz = (z ?? 0) - (other.z ?? 0);
    return math.sqrt(math.pow(dx, 2) + math.pow(dy, 2) + math.pow(dz, 2));
  }
}
