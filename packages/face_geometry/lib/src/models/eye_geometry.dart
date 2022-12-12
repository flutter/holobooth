// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:meta/meta.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;

class EyeKeypoint extends Equatable {
  EyeKeypoint({
    required this.topEyeLid,
    required this.bottomEyeLid,
  }) : distance = topEyeLid.distanceTo(bottomEyeLid);

  /// Creates an instance of [EyeKeypoint] from the left eye keypoints.
  EyeKeypoint.left(List<tf.Keypoint> keypoints)
      : this(topEyeLid: keypoints[159], bottomEyeLid: keypoints[145]);

  /// Creates an instance of [EyeKeypoint] from the right eye keypoints.
  EyeKeypoint.right(List<tf.Keypoint> keypoints)
      : this(topEyeLid: keypoints[386], bottomEyeLid: keypoints[374]);

  final tf.Keypoint topEyeLid;
  final tf.Keypoint bottomEyeLid;
  final double distance;

  @override
  List<Object?> get props => [topEyeLid, bottomEyeLid, distance];
}

@immutable
abstract class _EyeGeometry extends Equatable {
  _EyeGeometry._compute({
    required EyeKeypoint eyeKeypoint,
    required tf.BoundingBox boundingBox,
    double? previousMinRatio,
    double? previousMaxRatio,
    double? previousMeanRatio,
    int generation = 0,
  })  : distance = _computeDistanceRatio(
          distance: eyeKeypoint.distance,
          faceHeight: boundingBox.height,
        ),
        meanRatio = _computeMeanRatio(
          distance: eyeKeypoint.distance,
          faceHeight: boundingBox.height,
          previousMeanRatio: previousMeanRatio,
          generation: generation,
        ),
        minRatio = _computeMinRatio(
          distance: eyeKeypoint.distance,
          faceHeight: boundingBox.height,
          previousMinRatio: previousMinRatio,
        ),
        maxRatio = _computeMaxRatio(
          distance: eyeKeypoint.distance,
          faceHeight: boundingBox.height,
          previousMaxRatio: previousMaxRatio,
        ),
        isClosed = _computeIsClosed(
          distance: eyeKeypoint.distance,
          faceHeight: boundingBox.height,
          minRatio: _computeMinRatio(
            distance: eyeKeypoint.distance,
            faceHeight: boundingBox.height,
            previousMinRatio: previousMinRatio,
          ),
          maxRatio: _computeMaxRatio(
            distance: eyeKeypoint.distance,
            faceHeight: boundingBox.height,
            previousMaxRatio: previousMaxRatio,
          ),
        ),
        _generation = generation + 1;

  /// An empty instance of [_EyeGeometry].
  ///
  /// This is used when the keypoints are not available.
  const _EyeGeometry._empty({
    double? minRatio,
    double? maxRatio,
    this.meanRatio,
    int generation = 0,
  })  : distance = 0,
        isClosed = false,
        maxRatio = minRatio,
        minRatio = maxRatio,
        _generation = generation;

  /// The minimum value at which [_EyeGeometry] recognizes an eye closure.
  static const _minEyeRatio = 0.3;

  static double? _computeDistanceRatio({
    required double distance,
    required num faceHeight,
  }) {
    if (faceHeight == 0 || faceHeight < distance) return null;
    return distance / faceHeight;
  }

  /// Computes the mean distance of some [EyeKeypoint].
  static double? _computeMeanRatio({
    required double distance,
    required int generation,
    required num faceHeight,
    required double? previousMeanRatio,
  }) {
    if (faceHeight == 0 || faceHeight < distance) return previousMeanRatio;

    final heightRatio = distance / faceHeight;
    final total = (previousMeanRatio ?? 0) * generation + heightRatio;
    return total / (generation + 1);
  }

  static double? _computeMaxRatio({
    required double distance,
    required num faceHeight,
    required double? previousMaxRatio,
  }) {
    if (faceHeight == 0 || faceHeight < distance) return previousMaxRatio;

    final heightRatio = distance / faceHeight;
    return (previousMaxRatio == null || heightRatio > previousMaxRatio) &&
            heightRatio < 1
        ? heightRatio
        : previousMaxRatio;
  }

  static double? _computeMinRatio({
    required double distance,
    required num faceHeight,
    required double? previousMinRatio,
  }) {
    if (faceHeight == 0 || faceHeight < distance) return previousMinRatio;

    final heightRatio = distance / faceHeight;
    return ((previousMinRatio == null || heightRatio < previousMinRatio) &&
            heightRatio > 0)
        ? heightRatio
        : previousMinRatio;
  }

  static bool _computeIsClosed({
    required double distance,
    required num faceHeight,
    required double? minRatio,
    required double? maxRatio,
  }) {
    if (faceHeight == 0 || faceHeight < distance) return false;

    final heightRatio = distance / faceHeight;
    final enoughData = (minRatio != null && maxRatio != null) &&
        !((minRatio / maxRatio) > 0.5);

    if (enoughData) {
      final percent = (heightRatio - minRatio) / (maxRatio - minRatio);
      return percent < _minEyeRatio;
    } else {
      return distance < 1;
    }
  }

  /// The number of keypoints that have been used to compute [meanRatio].
  final int _generation;

  /// The maxmium ratio between the eye distance and the face height.
  final double? maxRatio;

  /// The minimum ratio between the eye distance and the face height.
  final double? minRatio;

  /// Whether the eye is closed or not.
  ///
  /// Detection works after the first blink to make sure we have the correct
  /// minimum and maximum values.
  final bool isClosed;

  /// The distance between the top and bottom eye lids.
  final double? distance;

  /// The mean distance between the top and bottom eye lids.
  final double? meanRatio;

  /// Update the eye geometry.
  _EyeGeometry update(
    List<tf.Keypoint> keypoints,
    tf.BoundingBox boundingBox,
  );

  @override
  List<Object?> get props => [
        isClosed,
        distance,
        meanRatio,
        minRatio,
        maxRatio,
      ];
}

class LeftEyeGeometry extends _EyeGeometry {
  factory LeftEyeGeometry({
    required List<tf.Keypoint> keypoints,
    required tf.BoundingBox boundingBox,
  }) {
    if (keypoints.length > 160) {
      return LeftEyeGeometry._compute(
        eyeKeypoint: EyeKeypoint.left(keypoints),
        boundingBox: boundingBox,
      );
    } else {
      return const LeftEyeGeometry.empty();
    }
  }

  LeftEyeGeometry._compute({
    required super.eyeKeypoint,
    required super.boundingBox,
    super.generation,
    super.previousMinRatio,
    super.previousMaxRatio,
    super.previousMeanRatio,
  }) : super._compute();

  const LeftEyeGeometry.empty({
    super.minRatio,
    super.maxRatio,
    super.meanRatio,
    super.generation,
  }) : super._empty();

  @override
  LeftEyeGeometry update(
    List<tf.Keypoint> keypoints,
    tf.BoundingBox boundingBox,
  ) {
    if (keypoints.length > 160) {
      return LeftEyeGeometry._compute(
        eyeKeypoint: EyeKeypoint.left(keypoints),
        boundingBox: boundingBox,
        previousMinRatio: minRatio,
        previousMaxRatio: maxRatio,
        previousMeanRatio: meanRatio,
        generation: _generation,
      );
    } else {
      return LeftEyeGeometry.empty(
        minRatio: minRatio,
        maxRatio: maxRatio,
        meanRatio: meanRatio,
        generation: _generation,
      );
    }
  }
}

class RightEyeGeometry extends _EyeGeometry {
  factory RightEyeGeometry({
    required List<tf.Keypoint> keypoints,
    required tf.BoundingBox boundingBox,
  }) {
    if (keypoints.length > 160) {
      return RightEyeGeometry._compute(
        eyeKeypoint: EyeKeypoint.left(keypoints),
        boundingBox: boundingBox,
      );
    } else {
      return const RightEyeGeometry.empty();
    }
  }

  RightEyeGeometry._compute({
    required super.eyeKeypoint,
    required super.boundingBox,
    super.previousMinRatio,
    super.previousMaxRatio,
    super.previousMeanRatio,
    super.generation,
  }) : super._compute();

  const RightEyeGeometry.empty({
    super.minRatio,
    super.maxRatio,
    super.meanRatio,
    super.generation,
  }) : super._empty();

  @override
  RightEyeGeometry update(
    List<tf.Keypoint> keypoints,
    tf.BoundingBox boundingBox,
  ) {
    if (keypoints.length > 160) {
      return RightEyeGeometry._compute(
        eyeKeypoint: EyeKeypoint.right(keypoints),
        boundingBox: boundingBox,
        previousMinRatio: minRatio,
        previousMaxRatio: maxRatio,
        previousMeanRatio: meanRatio,
        generation: _generation,
      );
    } else {
      return RightEyeGeometry.empty(
        minRatio: minRatio,
        maxRatio: maxRatio,
        meanRatio: meanRatio,
        generation: _generation,
      );
    }
  }
}
