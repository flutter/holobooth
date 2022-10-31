// ignore_for_file: must_be_immutable

import 'package:face_geometry/face_geometry.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

/// {@template face_geometry}
/// The class includes geometry for face.
/// {@endtemplate}
class FaceGeometry extends BaseGeometry {
  /// {@macro face_geometry}
  FaceGeometry(
    super.keypoints,
    super.boundingBox,
  )   : direction = FaceDirection(keypoints, boundingBox),
        leftEye = EyeGeometry.left(keypoints, boundingBox),
        rightEye = EyeGeometry.right(keypoints, boundingBox),
        mouth = MouthGeometry(keypoints, boundingBox);

  /// {@macro face_direction}
  FaceDirection direction;

  /// {@macro eye_geometry}
  EyeGeometry leftEye;

  /// {@macro eye_geometry}
  EyeGeometry rightEye;

  /// {@macro mouth_geometry}
  MouthGeometry mouth;

  @override
  void update(
    List<Keypoint> newKeypoints,
    BoundingBox newBoundingBox,
  ) {
    keypoints = newKeypoints;
    boundingBox = newBoundingBox;

    direction.update(newKeypoints, newBoundingBox);
    leftEye.update(newKeypoints, newBoundingBox);
    rightEye.update(newKeypoints, newBoundingBox);
    mouth.update(newKeypoints, newBoundingBox);
  }

  @override
  List<Object?> get props => [
        keypoints,
        boundingBox,
        direction,
        leftEye,
        rightEye,
        mouth,
      ];
}
