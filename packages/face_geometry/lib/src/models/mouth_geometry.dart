// ignore_for_file: must_be_immutable

import 'package:face_geometry/face_geometry.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

/// An eyeballed estimated minimum mouth to face ratio.
///
/// This represents the minimum height of the mouth in comparison to the face
/// height.
const _minMouthFaceRatio = 0.02;

/// {@template mouth_geometry}
/// An object which holds data for eye blink.
/// {@endtemplate}
class MouthGeometry extends BaseGeometry {
  /// {@macro mouth_geometry}
  MouthGeometry(super.keypoints, super.boundingBox);

  /// The distance between the top lip and the bottom lip.
  double get mouthDistance {
    if (keypoints.length < 15) return 0;
    final topLipPoint = keypoints[13];
    final bottomLipPoint = keypoints[14];
    return topLipPoint.distanceTo(bottomLipPoint);
  }

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

  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  void update(
    List<Keypoint> newKeypoints,
    BoundingBox newBoundingBox,
  ) {
    keypoints = newKeypoints;
    boundingBox = newBoundingBox;
  }
}
