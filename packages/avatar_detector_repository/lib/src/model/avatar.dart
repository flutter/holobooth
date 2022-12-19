import 'package:equatable/equatable.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:meta/meta.dart';

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
    required this.leftEyeIsClosed,
    required this.rightEyeIsClosed,
    required this.distance,
  });

  /// {@macro avatar}
  Avatar.fromFaceGeometry(
    FaceGeometry faceGeometry,
  )   : hasMouthOpen = faceGeometry.mouth.isOpen,
        mouthDistance = faceGeometry.mouth.distance,
        direction = faceGeometry.direction.value,
        leftEyeIsClosed = faceGeometry.leftEye.isClosed,
        rightEyeIsClosed = faceGeometry.rightEye.isClosed,
        distance = faceGeometry.distance.value;

  /// {@macro avatar}
  static const zero = Avatar(
    hasMouthOpen: false,
    mouthDistance: 0,
    direction: Vector3.zero,
    leftEyeIsClosed: false,
    rightEyeIsClosed: false,
    distance: 0,
  );

  /// Indicates whether the [Avatar] has the mouth open.
  final bool hasMouthOpen;

  /// The distance between the top and bottom lip.
  final double mouthDistance;

  /// Direction of the [Avatar] represented by x, y and z.
  final Vector3 direction;

  /// Whether the [Avatar] has the left eye closed.
  final bool leftEyeIsClosed;

  /// Whether the [Avatar] has the right eye closed.
  final bool rightEyeIsClosed;

  /// The value that correlates to the distance the [Avatar] is from the camera.
  ///
  /// The greater the value, the closer the user is to the camera.
  ///
  /// The value is between 0 and 1.
  final double distance;

  @override
  List<Object?> get props => [
        hasMouthOpen,
        mouthDistance,
        direction,
        leftEyeIsClosed,
        rightEyeIsClosed,
        distance,
      ];
}
