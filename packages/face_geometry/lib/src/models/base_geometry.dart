import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

/// {@template base_face_geometry}
/// Base geometry class which contains list of [Keypoint] and [BoundingBox].
/// {@endtemplate}
abstract class BaseFaceGeometry {
  /// {@macro base_face_geometry}
  BaseFaceGeometry(this.keypoints, this.boundingBox);

  /// List of [Keypoint] which contains the position of the keypoints.
  List<Keypoint> keypoints;

  /// The bounding box of the face.
  BoundingBox boundingBox;

  /// Updates the [keypoints] and [boundingBox] with the new values.
  void update(
    List<Keypoint> newKeypoints,
    BoundingBox newBoundingBox,
  );
}
