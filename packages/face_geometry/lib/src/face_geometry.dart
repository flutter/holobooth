import 'package:equatable/equatable.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:meta/meta.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;

/// {@template face_geometry}
/// Geometric data for a [tf.Face].
/// {@endtemplate}
@immutable
class FaceGeometry extends Equatable {
  /// {@macro face_geometry}
  ///
  /// Creating a new face instead of using [update] will clear the previous
  /// face data.
  ///
  /// It is recommened to use [FaceGeometry.fromFace] once and then
  /// use [update] to update the face data.
  FaceGeometry.fromFace(tf.Face face)
      : this._(
          direction: FaceDirection(keypoints: face.keypoints),
          leftEye: LeftEyeGeometry(
            keypoints: face.keypoints,
            boundingBox: face.boundingBox,
          ),
          rightEye: RightEyeGeometry(
            keypoints: face.keypoints,
            boundingBox: face.boundingBox,
          ),
          mouth: MouthGeometry(
            keypoints: face.keypoints,
            boundingBox: face.boundingBox,
          ),
        );

  const FaceGeometry._({
    required this.direction,
    required this.mouth,
    required this.leftEye,
    required this.rightEye,
  });

  /// {@macro face_direction}
  final FaceDirection direction;

  /// {@macro eye_geometry}
  final LeftEyeGeometry leftEye;

  /// {@macro eye_geometry}
  final RightEyeGeometry rightEye;

  /// {@macro mouth_geometry}
  final MouthGeometry mouth;

  /// Updates the [FaceGeometry] with the new [face].
  FaceGeometry update(tf.Face face) {
    return FaceGeometry._(
      direction: FaceDirection(keypoints: face.keypoints),
      mouth: MouthGeometry(
        keypoints: face.keypoints,
        boundingBox: face.boundingBox,
      ),
      leftEye: leftEye.update(face.keypoints, face.boundingBox),
      rightEye: rightEye.update(face.keypoints, face.boundingBox),
    );
  }

  @override
  List<Object?> get props => [direction, leftEye, rightEye, mouth];
}
