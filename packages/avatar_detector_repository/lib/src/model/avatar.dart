import 'package:equatable/equatable.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:meta/meta.dart';

/// {@template avatar}
/// Avatar representation.
/// {@endtemplate}
@immutable
class Avatar extends Equatable {
  /// {@macro avatar}
  const Avatar({
    required this.isValid,
    required this.hasMouthOpen,
    required this.mouthDistance,
    required this.rotation,
    required this.distance,
    required this.leftEyeGeometry,
    required this.rightEyeGeometry,
  });

  /// {@macro avatar}
  static const zero = Avatar(
    hasMouthOpen: false,
    mouthDistance: 0,
    rotation: Vector3.zero,
    distance: 0,
    leftEyeGeometry: LeftEyeGeometry.empty(),
    rightEyeGeometry: RightEyeGeometry.empty(),
    isValid: true,
  );

  /// Indicates whether the [Avatar] has the mouth open.
  final bool hasMouthOpen;

  /// The distance between the top and bottom lip.
  final double mouthDistance;

  /// Direction of the [Avatar] represented by x, y and z.
  final Vector3 rotation;

  /// The value that correlates to the distance the [Avatar] is from the camera.
  ///
  /// The greater the value, the closer the user is to the camera.
  ///
  /// The value is between 0 and 1.
  final double distance;

  /// The [LeftEyeGeometry] of the [Avatar].
  final LeftEyeGeometry leftEyeGeometry;

  /// The [RightEyeGeometry] of the [Avatar].
  final RightEyeGeometry rightEyeGeometry;

  /// Whether or not the [Avatar] is fully within bounds.
  final bool isValid;

  @override
  List<Object?> get props => [
        hasMouthOpen,
        mouthDistance,
        rotation,
        distance,
        leftEyeGeometry,
        rightEyeGeometry
      ];
}
