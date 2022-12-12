import 'package:equatable/equatable.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;

class _MouthKeypoints {
  _MouthKeypoints({
    required this.topLip,
    required this.bottomLip,
  }) : distance = topLip.distanceTo(bottomLip);

  /// The top lip keypoint.
  ///
  /// The highest lip keypoint when facing straight to the camera.
  final tf.Keypoint topLip;

  /// The bottom lip keypoint.
  ///
  /// The lowest lip keypoint when facing straight to the camera.
  final tf.Keypoint bottomLip;

  /// The distance between the top and bottom lip.
  ///
  /// Unlike [MouthGeometry.distance] this value is not a ratio but the actual
  /// distance between the [topLip] and [bottomLip].
  final double distance;
}

/// {@template mouth_geometry}
/// A class that represents the geometry of the mouth.
/// {@endtemplate}
class MouthGeometry extends Equatable {
  /// {@macro mouth_geometry}
  factory MouthGeometry({
    required List<tf.Keypoint> keypoints,
    required tf.BoundingBox boundingBox,
  }) {
    final hasEnoughKeypoints = keypoints.length > 15;
    if (!hasEnoughKeypoints) return const MouthGeometry._empty();
    final mouthKeypoints = _MouthKeypoints(
      topLip: keypoints[13],
      bottomLip: keypoints[14],
    );
    final canComputeRatio =
        boundingBox.height > 0 && boundingBox.height > mouthKeypoints.distance;
    if (!canComputeRatio) return const MouthGeometry._empty();

    final distance = mouthKeypoints.distance / boundingBox.height;
    return MouthGeometry._(
      isOpen: _isOpen(mouthKeypoints: mouthKeypoints, distance: distance),
      distance: distance,
    );
  }

  /// {@macro mouth_geometry}
  const MouthGeometry._({
    required this.isOpen,
    required this.distance,
  });

  /// An empty instance of [MouthGeometry].
  ///
  /// This is the default value of [MouthGeometry] whenever there is not enough
  /// data to compute the geometry. Like for example, when there are not enough
  /// keypoints or the bounding box is too small.
  const MouthGeometry._empty()
      : isOpen = false,
        distance = 0;

  /// Eye-balled distance that represents the minimum height of the mouth to be
  /// considered open.
  ///
  /// This value considers the distance to be a ratio of the face height.
  static const _minMouthOpenedDistance = 0.02;

  static bool _isOpen({
    required _MouthKeypoints mouthKeypoints,
    required num distance,
  }) {
    if (mouthKeypoints.distance > 1) {
      if (distance == 0) {
        return false;
      } else {
        return distance > _minMouthOpenedDistance;
      }
    }
    return false;
  }

  /// Defines if the mouth is open.
  final bool isOpen;

  /// The distance between the top and bottom lip.
  ///
  /// To avoid uncorrelated distances due to how close the face is to the camera
  /// the distance is given as a ratio of the face height. Therefore the value
  /// is between 0 and 1.
  final double distance;

  @override
  List<Object?> get props => [isOpen, distance];
}
