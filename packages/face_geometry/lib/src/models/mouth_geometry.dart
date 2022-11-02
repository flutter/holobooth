import 'package:equatable/equatable.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;

/// {@template mouth_geometry}
/// A class that represents the geometry of the mouth.
/// {@endtemplate}
class MouthGeometry extends Equatable {
  /// {@macro mouth_geometry}
  factory MouthGeometry({
    required List<tf.Keypoint> keypoints,
    required tf.BoundingBox boundingBox,
  }) {
    return keypoints.length > 15
        ? MouthGeometry._compute(keypoints: keypoints, boundingBox: boundingBox)
        : const MouthGeometry._empty();
  }

  /// {@macro mouth_geometry}
  MouthGeometry._compute({
    required List<tf.Keypoint> keypoints,
    required tf.BoundingBox boundingBox,
  }) : isOpen = _isOpen(
          topLip: keypoints[13],
          bottomLip: keypoints[14],
          faceHeight: boundingBox.height,
        );

  /// An empty instance of [MouthGeometry].
  ///
  /// This is used when the keypoints are not available.
  const MouthGeometry._empty() : isOpen = false;

  /// This represents the minimum height of the mouth in comparison to the face
  /// height.
  static const _minMouthFaceRatio = 0.02;

  static bool _isOpen({
    required tf.Keypoint topLip,
    required tf.Keypoint bottomLip,
    required num faceHeight,
  }) {
    final distance = topLip.distanceTo(bottomLip);
    if (distance > 1) {
      final heightRatio = distance / faceHeight;
      if (heightRatio == 0) {
        return false;
      } else {
        return heightRatio > _minMouthFaceRatio;
      }
    }

    return false;
  }

  /// Defines if the mouth is open based on hight and face height.
  final bool isOpen;

  @override
  List<Object?> get props => [isOpen];
}
