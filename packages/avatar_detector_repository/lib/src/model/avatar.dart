import 'package:equatable/equatable.dart';
import 'package:face_geometry/face_geometry.dart';

/// {@template avatar}
/// Avatar representation.
/// {@endtemplate}
class Avatar extends Equatable {
  /// {@macro avatar}
  Avatar.fromFaceGeomtry(
    FaceGeometry faceGeometry,
  )   : hasMouthOpen = faceGeometry.mouth.isOpen,
        direction = faceGeometry.direction.value;

  /// Indicates whether the [Avatar] has the mouth open.
  final bool hasMouthOpen;

  /// Direction of the [Avatar] represented by x, y and z.
  final Vector3 direction;

  @override
  List<Object?> get props => [hasMouthOpen, direction];
}
