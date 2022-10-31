import 'package:equatable/equatable.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:tensorflow_models/tensorflow_models.dart';

/// {@template avatar}
/// Avatar representation.
/// {@endtemplate}
class Avatar extends Equatable {
  /// {@macro avatar}
  const Avatar({
    required this.hasMouthOpen,
    required this.direction,
  });

  /// Build an [Avatar] based on [Face].
  factory Avatar.fromFace(Face face) {
    final faceGeometry = FaceGeometry(face.keypoints, face.boundingBox);

    return Avatar(
      hasMouthOpen: faceGeometry.mouth.isOpen,
      direction: faceGeometry.direction.calculate(),
    );
  }

  /// Indicates whether the [Avatar] has the mouth open.
  final bool hasMouthOpen;

  /// Direction of the [Avatar] represented by x, y and z.
  final Vector3 direction;

  @override
  List<Object?> get props => [hasMouthOpen, direction];
}
