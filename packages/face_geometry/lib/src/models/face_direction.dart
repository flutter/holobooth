import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:meta/meta.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;

/// {@template face_direction}
/// Calculation to detect the direction of the face.
/// {@endtemplate}
@immutable
class FaceDirection extends Equatable {
  /// {@macro face_direction}
  factory FaceDirection({required List<tf.Keypoint> keypoints}) {
    return keypoints.length > 357
        ? FaceDirection._compute(keypoints: keypoints)
        : const FaceDirection._empty();
  }

  FaceDirection._compute({
    required List<tf.Keypoint> keypoints,
  }) : value = _value(
          foreheadTopCenter: keypoints[10],
          chinBottomCenter: keypoints[152],
          leftCheeckBone: keypoints[226],
          rightCheeckBone: keypoints[446],
        );

  /// An empty instance of [MouthGeometry].
  ///
  /// This is used when the keypoints are not available.
  const FaceDirection._empty() : value = Vector3.zero;

  static double _l2Norm(List<num> vec) {
    var norm = 0.0;
    for (final v in vec) {
      norm += v * v;
    }
    return math.sqrt(norm);
  }

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
    final verticalHypotenuse = _l2Norm([verticalAdjacent, verticalOpposite]);
    final verticalCos = verticalAdjacent / verticalHypotenuse;

    final faceHorizontalCentralPoint = Vector3(
      (leftCheeckBone.x + rightCheeckBone.x) * 0.5,
      0,
      ((leftCheeckBone.z ?? 0) + (rightCheeckBone.z ?? 0)) * 0.5,
    );

    final horizontalAdjacent =
        (leftCheeckBone.z ?? 0) - faceHorizontalCentralPoint.z;
    final horizontalOpposite = rightCheeckBone.x - faceHorizontalCentralPoint.x;

    final horizontalHypotenuse =
        _l2Norm([horizontalAdjacent, horizontalOpposite]);
    final horizontalCos = horizontalAdjacent / horizontalHypotenuse;

    return Vector3(
      verticalCos,
      horizontalCos,
      0,
    );
  }

  /// The value of the direction of the face.
  final Vector3 value;

  @override
  List<Object?> get props => [value];
}
