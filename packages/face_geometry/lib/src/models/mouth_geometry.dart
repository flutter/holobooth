// ignore_for_file: must_be_immutable

import 'package:face_geometry/face_geometry.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

/// This represents the minimum height of the mouth in comparison to the face
/// height.
const _minMouthFaceRatio = 0.02;

/// {@template mouth_geometry}
/// An object which holds data for mouth.
/// {@endtemplate}
class MouthGeometry extends BaseGeometry {
  /// {@macro mouth_geometry}
  MouthGeometry(super.keypoints, super.boundingBox);

  /// The distance between the top lip and the bottom lip.
  double get distance {
    if (keypoints.length < 15) return 0;
    final topLipPoint = keypoints[13];
    final bottomLipPoint = keypoints[14];
    return topLipPoint.distanceTo(bottomLipPoint);
  }

  /// Defines if the mouth is open based on hight and face height.
  bool get isOpen {
    if (distance > 1) {
      if (boundingBox.height == 0) return false;
      final heightRatio = distance / boundingBox.height;
      if (heightRatio == 0) return false;

      return heightRatio > _minMouthFaceRatio;
    }

    return false;
  }

  @override
  List<Object?> get props => [
        keypoints,
        boundingBox,
      ];

  @override
  void update(
    List<Keypoint> newKeypoints,
    BoundingBox newBoundingBox,
  ) {
    keypoints = newKeypoints;
    boundingBox = newBoundingBox;
  }
}
