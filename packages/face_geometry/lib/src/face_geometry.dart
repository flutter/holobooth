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
  /// It is recommended to use the [FaceGeometry] constructor once and then
  /// use [update] to update the face data.
  ///
  /// The [size] is the size of the image that the face was detected on.
  FaceGeometry({
    required tf.Face face,
    required tf.Size size,
  }) : this._(
          rotation: FaceRotation(keypoints: face.keypoints),
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
          distance: FaceDistance(
            boundingBox: face.boundingBox,
            imageSize: size,
          ),
        );

  const FaceGeometry._({
    required this.rotation,
    required this.mouth,
    required this.leftEye,
    required this.rightEye,
    required this.distance,
  });

  /// {@macro face_rotation}
  final FaceRotation rotation;

  /// {@macro eye_geometry}
  final LeftEyeGeometry leftEye;

  /// {@macro eye_geometry}
  final RightEyeGeometry rightEye;

  /// {@macro mouth_geometry}
  final MouthGeometry mouth;

  /// {@macro face_distance}
  final FaceDistance distance;

  /// Updates the [FaceGeometry] with the new [face].
  ///
  /// The [size] is the size of the image that the face was detected on.
  FaceGeometry update({
    required tf.Face face,
    required tf.Size size,
  }) {
    return FaceGeometry._(
      rotation: FaceRotation(keypoints: face.keypoints),
      mouth: MouthGeometry(
        keypoints: face.keypoints,
        boundingBox: face.boundingBox,
      ),
      leftEye: leftEye.update(face.keypoints, face.boundingBox),
      rightEye: rightEye.update(face.keypoints, face.boundingBox),
      distance: FaceDistance(
        boundingBox: face.boundingBox,
        imageSize: size,
      ),
    );
  }

  @override
  List<Object?> get props => [rotation, leftEye, rightEye, mouth];
}
