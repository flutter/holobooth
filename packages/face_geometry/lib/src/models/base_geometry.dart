// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

/// {@template base_geometry}
/// Base geometry class which contains list of [Keypoint] and [BoundingBox].
/// {@endtemplate}
abstract class BaseGeometry extends Equatable {
  /// {@macro base_geometry}
  BaseGeometry(this.keypoints, this.boundingBox);

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
