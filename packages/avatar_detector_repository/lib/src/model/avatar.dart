import 'package:equatable/equatable.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:meta/meta.dart';
import 'package:tensorflow_models/tensorflow_models.dart';

/// {@template avatar}
/// Avatar representation.
/// {@endtemplate}
@immutable
class Avatar extends Equatable {
  /// {@macro avatar}
  @visibleForTesting
  const Avatar({
    required this.hasMouthOpen,
    required this.mouthDistance,
    required this.direction,
    required this.distance,
    required this.leftEyeGeometry,
    required this.rightEyeGeometry,
  });

  /// {@macro avatar}
  Avatar.fromFaceGeometry(
    FaceGeometry faceGeometry,
  )   : hasMouthOpen = faceGeometry.mouth.isOpen,
        mouthDistance = faceGeometry.mouth.distance,
        direction = faceGeometry.direction.value,
        distance = faceGeometry.distance.value,
        leftEyeGeometry = faceGeometry.leftEye,
        rightEyeGeometry = faceGeometry.rightEye;

  /// {@macro avatar}
  static const zero = Avatar(
    hasMouthOpen: false,
    mouthDistance: 0,
    direction: Vector3.zero,
    distance: 1,
    leftEyeGeometry: LeftEyeGeometry.empty(),
    rightEyeGeometry: RightEyeGeometry.empty(),
  );

  /// Indicates whether the [Avatar] has the mouth open.
  final bool hasMouthOpen;

  /// The distance between the top and bottom lip.
  final double mouthDistance;

  /// Direction of the [Avatar] represented by x, y and z.
  final Vector3 direction;

  /// The value that correlates to the distance the [Avatar] is from the camera.
  ///
  /// The greater the value, the closer the user is to the camera.
  ///
  /// The value is between 0 and 1.
  final double distance;

  final LeftEyeGeometry leftEyeGeometry;

  final RightEyeGeometry rightEyeGeometry;

  @override
  List<Object?> get props => [
        hasMouthOpen,
        mouthDistance,
        direction,
        distance,
        leftEyeGeometry,
        rightEyeGeometry
      ];
}
