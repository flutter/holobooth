// ignore_for_file: must_be_immutable

import 'package:face_geometry/face_geometry.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

/// {@template face_geometry}
/// The class includes geometry for face.
/// {@endtemplate}
class FaceGeometry extends BaseFaceGeometry {
  /// {@macro face_geometry}
  FaceGeometry(
    super.keypoints,
    super.boundingBox,
  )   : direction = FaceDirection(keypoints),
        leftEye = LeftEyeGeometry(
          keypoints: keypoints,
          boundingBox: boundingBox,
        ),
        rightEye = RightEyeGeometry(
          keypoints: keypoints,
          boundingBox: boundingBox,
        ),
        mouth = MouthGeometry(keypoints, boundingBox);

  /// {@macro face_direction}
  FaceDirection direction;

  /// {@macro eye_geometry}
  LeftEyeGeometry leftEye;

  /// {@macro eye_geometry}
  RightEyeGeometry rightEye;

  /// {@macro mouth_geometry}
  MouthGeometry mouth;

  @override
  void update(
    List<Keypoint> newKeypoints,
    BoundingBox newBoundingBox,
  ) {
    keypoints = newKeypoints;
    boundingBox = newBoundingBox;

    direction = FaceDirection(keypoints);
    leftEye = leftEye.update(newKeypoints, newBoundingBox);
    rightEye = rightEye.update(newKeypoints, newBoundingBox);
    mouth.update(newKeypoints, newBoundingBox);
  }
}
