import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:meta/meta.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;

/// {@template face_rotation}
/// Calculations to detect the rotation of a face.
/// {@endtemplate}
@immutable
class FaceRotation extends Equatable {
  /// {@macro face_rotation}
  factory FaceRotation({required List<tf.Keypoint> keypoints}) {
    return keypoints.length > 447
        ? FaceRotation._compute(keypoints: keypoints)
        : const FaceRotation._empty();
  }

  FaceRotation._compute({
    required List<tf.Keypoint> keypoints,
  }) : value = _value(
          foreheadTopCenter: keypoints[10],
          chinBottomCenter: keypoints[152],
          leftCheeckBone: keypoints[226],
          rightCheeckBone: keypoints[446],
        );

  /// An empty instance of [FaceRotation].
  ///
  /// This is used when the keypoints required for [FaceRotation._compute] are
  /// not available.
  const FaceRotation._empty() : value = Vector3.zero;

  static Vector3 _value({
    required tf.Keypoint leftCheeckBone,
    required tf.Keypoint rightCheeckBone,
    required tf.Keypoint foreheadTopCenter,
    required tf.Keypoint chinBottomCenter,
  }) {
    final faceVerticalCentralPoint = Vector3(
      0,
      (foreheadTopCenter.y + chinBottomCenter.y) / 2,
      ((foreheadTopCenter.z ?? 0) + (chinBottomCenter.z ?? 0)) / 2,
    );
    final verticalAdjacent =
        (foreheadTopCenter.z ?? 0) - faceVerticalCentralPoint.z;
    final verticalOpposite = foreheadTopCenter.y - faceVerticalCentralPoint.y;
    final verticalHypotenuse = _hypotenuse(verticalAdjacent, verticalOpposite);
    final verticalCos =
        verticalHypotenuse != 0 ? verticalAdjacent / verticalHypotenuse : .0;

    final faceHorizontalCentralPoint = Vector3(
      (leftCheeckBone.x + rightCheeckBone.x) / 2,
      0,
      ((leftCheeckBone.z ?? 0) + (rightCheeckBone.z ?? 0)) / 2,
    );
    final horizontalAdjacent =
        (leftCheeckBone.z ?? 0) - faceHorizontalCentralPoint.z;
    final horizontalOpposite = rightCheeckBone.x - faceHorizontalCentralPoint.x;
    final horizontalHypotenuse =
        _hypotenuse(horizontalAdjacent, horizontalOpposite);
    final horizontalCos = horizontalHypotenuse != 0
        ? horizontalAdjacent / horizontalHypotenuse
        : .0;

    final faceDiagonalCentralPoint = Vector3(
      (foreheadTopCenter.x + chinBottomCenter.x) / 2,
      (foreheadTopCenter.y + chinBottomCenter.y) / 2,
      0,
    );
    final diagonalAdjacent = foreheadTopCenter.x - faceDiagonalCentralPoint.x;
    final diagonalOpposite = foreheadTopCenter.y - faceDiagonalCentralPoint.y;
    final diagonalHypotenuse = -_hypotenuse(diagonalAdjacent, diagonalOpposite);
    final diagonalCos =
        diagonalHypotenuse != 0 ? diagonalAdjacent / diagonalHypotenuse : .0;

    return Vector3(horizontalCos, verticalCos, diagonalCos);
  }

  /// The value of the rotation of the face.
  ///
  /// The value is a [Vector3] with values ranging from -1 to 1. The x value
  /// represents the horizontal rotation, the y value represents the vertical
  /// rotation, and the z value represents the diagonal rotation.
  final Vector3 value;

  @override
  List<Object?> get props => [value];
}

double _hypotenuse(double x, double y) => math.sqrt(x * x + y * y);
