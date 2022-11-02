// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:meta/meta.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;

@immutable
abstract class _EyeGeometry extends Equatable {
  _EyeGeometry._compute({
    required tf.Keypoint topEyeLid,
    required tf.Keypoint bottomEyeLid,
    required tf.BoundingBox boundingBox,
    double? minRatio,
    double? maxRatio,
  }) {
    final faceHeight = boundingBox.height;
    final distance = topEyeLid.distanceTo(bottomEyeLid);

    if (faceHeight != 0 || faceHeight > distance) {
      final heightRatio = distance / faceHeight;
      if (maxRatio == null || heightRatio > maxRatio) {
        _maxRatio = heightRatio;
      } else {
        _maxRatio = maxRatio;
      }
      if ((minRatio == null || heightRatio < minRatio) && heightRatio > 0) {
        _minRatio = heightRatio;
      } else {
        _minRatio = minRatio;
      }

      final firstAction = _minRatio == null ||
          _maxRatio == null ||
          ((_minRatio! / _maxRatio!) > 0.5);
      if (!firstAction) {
        final percent = (heightRatio - _minRatio!) / (_maxRatio! - _minRatio!);
        isClosed = percent < _minEyeRatio;
      } else {
        isClosed = distance < 1;
      }
    } else {
      isClosed = false;
      _maxRatio = maxRatio;
      _minRatio = minRatio;
    }
  }

  /// An empty instance of [_EyeGeometry].
  ///
  /// This is used when the keypoints are not available.
  _EyeGeometry.empty() : isClosed = false;

  /// The minimum value at which [_EyeGeometry] recognizes an eye closure.
  static const _minEyeRatio = 0.3;

  late final double? _maxRatio;
  late final double? _minRatio;

  /// Whether the eye is closed or not.
  ///
  /// Detection works after the first blink to make sure we have the correct
  /// minimum and maximum values.
  late bool isClosed;

  /// Update the eye geometry.
  _EyeGeometry update(
    List<tf.Keypoint> keypoints,
    tf.BoundingBox boundingBox,
  );
}

/// {@template left_eye_geometry}
/// Geometric data for the left eye.
/// {@endtemplate}
class LeftEyeGeometry extends _EyeGeometry {
  /// {@macro left_eye_geometry}
  ///
  /// Creating a new [LeftEyeGeometry] instead of using [update] will clear the
  /// previous eye data.
  ///
  /// It is recommened to use [LeftEyeGeometry] once and then [update] to
  /// update the face data.
  factory LeftEyeGeometry({
    required List<tf.Keypoint> keypoints,
    required tf.BoundingBox boundingBox,
    double? maxRatio,
    double? minRatio,
  }) {
    return keypoints.length > 160
        ? LeftEyeGeometry._compute(
            keypoints: keypoints,
            boundingBox: boundingBox,
            maxRatio: maxRatio,
            minRatio: minRatio,
          )
        : LeftEyeGeometry._empty();
  }

  LeftEyeGeometry._compute({
    required List<tf.Keypoint> keypoints,
    required super.boundingBox,
    super.maxRatio,
    super.minRatio,
  }) : super._compute(
          topEyeLid: keypoints[159],
          bottomEyeLid: keypoints[145],
        );

  LeftEyeGeometry._empty() : super.empty();

  @override
  LeftEyeGeometry update(
    List<tf.Keypoint> keypoints,
    tf.BoundingBox boundingBox,
  ) =>
      LeftEyeGeometry(
        keypoints: keypoints,
        boundingBox: boundingBox,
        maxRatio: _maxRatio,
        minRatio: _minRatio,
      );

  @override
  List<Object?> get props => [isClosed];
}

/// {@template right_eye_geometry}
/// Geometric data for the right eye.
/// {@endtemplate}
class RightEyeGeometry extends _EyeGeometry {
  /// {@macro right_eye_geometry}
  ///
  /// Creating a new [RightEyeGeometry] instead of using [update] will clear the
  /// previous eye data.
  ///
  /// It is recommened to use [RightEyeGeometry] once and then [update] to
  /// update the face data.
  factory RightEyeGeometry({
    required List<tf.Keypoint> keypoints,
    required tf.BoundingBox boundingBox,
    double? maxRatio,
    double? minRatio,
  }) {
    return keypoints.length > 387
        ? RightEyeGeometry._compute(
            keypoints: keypoints,
            boundingBox: boundingBox,
            maxRatio: maxRatio,
            minRatio: minRatio,
          )
        : RightEyeGeometry._empty();
  }

  RightEyeGeometry._compute({
    required List<tf.Keypoint> keypoints,
    required super.boundingBox,
    super.maxRatio,
    super.minRatio,
  }) : super._compute(
          topEyeLid: keypoints[386],
          bottomEyeLid: keypoints[374],
        );

  RightEyeGeometry._empty() : super.empty();

  @override
  RightEyeGeometry update(
    List<tf.Keypoint> keypoints,
    tf.BoundingBox boundingBox,
  ) =>
      RightEyeGeometry(
        keypoints: keypoints,
        boundingBox: boundingBox,
        maxRatio: _maxRatio,
        minRatio: _minRatio,
      );

  @override
  List<Object?> get props => [isClosed];
}
