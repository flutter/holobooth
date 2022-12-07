// ignore_for_file: public_member_api_docs

import 'dart:math' as math;

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
    double? previousMinDistance,
    double? previousMaxDistance,
    double? previousMeanDistance,
    int generation = 0,
  })  : distance = eyeKeypoint.distance,
        minDistance = math.min(
          eyeKeypoint.distance,
          previousMinDistance ?? eyeKeypoint.distance,
        ),
        maxDistance = math.max(
          eyeKeypoint.distance,
          previousMaxDistance ?? eyeKeypoint.distance,
        ),
        meanDistance = _computeMeanDistance(
          newEyeKeypoints: eyeKeypoint,
          previousMeanDistance: previousMeanDistance,
          generation: generation,
        ),
        _minRatio = _computeMinRatio(
          distance: eyeKeypoint.distance,
          faceHeight: boundingBox.height,
          previousMinRatio: previousMinRatio,
        ),
        _maxRatio = _computeMaxRatio(
          distance: eyeKeypoint.distance,
          faceHeight: boundingBox.height,
          previousMaxRatio: previousMaxRatio,
        ),
        _generation = generation + 1 {
    isClosed = _computeIsClosed(
      distance: eyeKeypoint.distance,
      faceHeight: boundingBox.height,
      minRatio: _minRatio,
      maxRatio: _maxRatio,
    );
  }

  /// An empty instance of [_EyeGeometry].
  ///
  /// This is used when the keypoints are not available.
  _EyeGeometry._empty({
    double? minRatio,
    double? maxRatio,
    this.maxDistance,
    this.minDistance,
    this.meanDistance,
    int generation = 0,
  })  : distance = 0,
        isClosed = false,
        _maxRatio = minRatio,
        _minRatio = maxRatio,
        _generation = generation;

  /// The minimum value at which [_EyeGeometry] recognizes an eye closure.
  static const _minEyeRatio = 0.3;

  /// Computes the mean distance of some [EyeKeypoint].
  static double _computeMeanDistance({
    required double? previousMeanDistance,
    required int generation,
    required EyeKeypoint newEyeKeypoints,
  }) {
    final totalDistance =
        (previousMeanDistance ?? 0) * generation + newEyeKeypoints.distance;
    return totalDistance / (generation + 1);
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

  /// The number of keypoints that have been used to compute [meanDistance].
  final int _generation;

  /// The maxmium ratio between the eye distance and the face height.
  final double? _maxRatio;

  /// The minimum ratio between the eye distance and the face height.
  final double? _minRatio;

  /// Whether the eye is closed or not.
  ///
  /// Detection works after the first blink to make sure we have the correct
  /// minimum and maximum values.
  late final bool isClosed;

  /// The distance between the top and bottom eye lids.
  final double distance;

  /// The maximum distance between the top and bottom eye lids.
  final double? maxDistance;

  /// The minimum distance between the top and bottom eye lids.
  final double? minDistance;

  /// The mean distance between the top and bottom eye lids.
  final double? meanDistance;

  /// Update the eye geometry.
  _EyeGeometry update(
    List<tf.Keypoint> keypoints,
    tf.BoundingBox boundingBox,
  );

  @override
  List<Object?> get props => [
        isClosed,
        distance,
        maxDistance,
        minDistance,
        meanDistance,
        _minRatio,
        _maxRatio,
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
      return LeftEyeGeometry._empty();
    }
  }

  LeftEyeGeometry._compute({
    required super.eyeKeypoint,
    required super.boundingBox,
    super.generation,
    super.previousMinRatio,
    super.previousMaxRatio,
    super.previousMinDistance,
    super.previousMaxDistance,
    super.previousMeanDistance,
  }) : super._compute();

  LeftEyeGeometry._empty({
    super.minRatio,
    super.maxRatio,
    super.maxDistance,
    super.minDistance,
    super.meanDistance,
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
        previousMinRatio: _minRatio,
        previousMaxRatio: _maxRatio,
        previousMinDistance: minDistance,
        previousMaxDistance: maxDistance,
        generation: _generation,
      );
    } else {
      return LeftEyeGeometry._empty(
        minRatio: _minRatio,
        maxRatio: _maxRatio,
        maxDistance: maxDistance,
        minDistance: minDistance,
        meanDistance: meanDistance,
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
      return RightEyeGeometry._empty();
    }
  }

  RightEyeGeometry._compute({
    required super.eyeKeypoint,
    required super.boundingBox,
    super.previousMinRatio,
    super.previousMaxRatio,
    super.previousMinDistance,
    super.previousMaxDistance,
    super.generation,
  }) : super._compute();

  RightEyeGeometry._empty({
    super.minRatio,
    super.maxRatio,
    super.maxDistance,
    super.minDistance,
    super.meanDistance,
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
        previousMinRatio: _minRatio,
        previousMaxRatio: _maxRatio,
        previousMinDistance: minDistance,
        previousMaxDistance: maxDistance,
        generation: _generation,
      );
    } else {
      return RightEyeGeometry._empty(
        minRatio: _minRatio,
        maxRatio: _maxRatio,
        maxDistance: maxDistance,
        minDistance: minDistance,
        meanDistance: meanDistance,
        generation: _generation,
      );
    }
  }
}
