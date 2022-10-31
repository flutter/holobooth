// ignore_for_file: must_be_immutable

import 'package:face_geometry/face_geometry.dart';
import 'package:meta/meta.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;

@immutable
abstract class _EyeGeometry {
  _EyeGeometry._({
    required tf.Keypoint topEyeLid,
    required tf.Keypoint bottomEyeLid,
    required tf.BoundingBox boundingBox,
    double? minRatio,
    double? maxRatio,
  }) {
    final faceHeight = boundingBox.height;
    if (faceHeight != 0) {
      final distance = topEyeLid.distanceTo(bottomEyeLid);
      final heightRatio = distance / faceHeight;
      if (heightRatio != 0) {
        if (_maxRatio == null || heightRatio > maxRatio!) {
          _maxRatio = heightRatio;
        }
        if ((_minRatio == null || heightRatio < minRatio!) && heightRatio > 0) {
          _minRatio = heightRatio;
        }

        final firstAction = _minRatio! / _maxRatio! < 0.5;
        if (firstAction) {
          final percent =
              (heightRatio - _minRatio!) / (_maxRatio! - _minRatio!);
          isClosed = percent < _minEyeRatio;
        }
      } else {
        isClosed = false;
        _maxRatio = maxRatio;
        _minRatio = minRatio;
      }
    } else {
      isClosed = false;
      _maxRatio = maxRatio;
      _minRatio = minRatio;
    }
  }

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
  LeftEyeGeometry({
    required List<tf.Keypoint> keypoints,
    required super.boundingBox,
    super.maxRatio,
    super.minRatio,
  }) : super._(
          topEyeLid: keypoints[159],
          bottomEyeLid: keypoints[145],
        );

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
}

/// {@template left_eye_geometry}
/// Geometric data for the right eye.
/// {@endtemplate}
class RightEyeGeometry extends _EyeGeometry {
  /// {@macro left_eye_geometry}
  RightEyeGeometry({
    required List<tf.Keypoint> keypoints,
    required super.boundingBox,
    super.maxRatio,
    super.minRatio,
  }) : super._(
          topEyeLid: keypoints[386],
          bottomEyeLid: keypoints[374],
        );

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
}
