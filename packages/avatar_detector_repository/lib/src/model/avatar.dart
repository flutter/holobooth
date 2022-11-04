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
  });

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
