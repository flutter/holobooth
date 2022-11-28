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
    required this.direction,
    required this.leftEyeIsClosed,
    required this.rightEyeIsClosed,
    required this.distance,
  });

  /// {@macro avatar}
  Avatar.fromFaceGeometry(
    FaceGeometry faceGeometry,
  )   : hasMouthOpen = faceGeometry.mouth.isOpen,
        direction = faceGeometry.direction.value,
        leftEyeIsClosed = faceGeometry.leftEye.isClosed,
        rightEyeIsClosed = faceGeometry.rightEye.isClosed,
        distance = faceGeometry.distance.value;

  /// {@macro avatar}
  static const zero = Avatar(
    hasMouthOpen: false,
    direction: Vector3.zero,
    leftEyeIsClosed: false,
    rightEyeIsClosed: false,
    distance: 0.5,
  );

  /// Indicates whether the [Avatar] has the mouth open.
  final bool hasMouthOpen;

  /// Direction of the [Avatar] represented by x, y and z.
  final Vector3 direction;

  /// Whether the [Avatar] has the left eye closed.
  final bool leftEyeIsClosed;

  /// Whether the [Avatar] has the right eye closed.
  final bool rightEyeIsClosed;

  /// The distance that the [Avatar] is from the camera.
  final double distance;

  @override
  List<Object?> get props => [
        hasMouthOpen,
        direction,
        leftEyeIsClosed,
        rightEyeIsClosed,
        distance,
      ];
}
