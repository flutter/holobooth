// ignore_for_file: must_be_immutable

import 'package:face_geometry/face_geometry.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

/// The minimum value at which [EyeGeometry] recognizes an eye closure.
const _minEyeRatio = 0.3;

/// Determines the position of the eye.
enum EyeSide {
  /// The left eye.
  left,

  /// The right eye.
  right
}

/// {@template eye_geometry}
/// An object which holds data for eye.
/// {@endtemplate}
class EyeGeometry extends BaseGeometry {
  /// {@macro eye_geometry}
  EyeGeometry.left(super.keypoints, super.boundingBox)
      : _eyeSide = EyeSide.left;

  /// {@macro eye_geometry}
  EyeGeometry.right(super.keypoints, super.boundingBox)
      : _eyeSide = EyeSide.right;

  final EyeSide _eyeSide;
  double? _maxRatio;
  double? _minRatio;

  /// The distance between the top eye lid and the bottom eye lid depends of
  /// [EyeSide] value.
  double get distance {
    if (_eyeSide == EyeSide.left) {
      if (keypoints.length < 160) return 0;
      final topEyeLid = keypoints[159];
      final bottomEyeLid = keypoints[145];
      return topEyeLid.distanceTo(bottomEyeLid);
    } else {
      if (keypoints.length < 387) return 0;
      final topEyeLid = keypoints[386];
      final bottomEyeLid = keypoints[374];
      return topEyeLid.distanceTo(bottomEyeLid);
    }
  }

  /// Define whether the first action, e.g. close, was detected and we have the
  /// correct min and max values.
  bool _firstAction = false;

  /// Detect if the eye is closed.
  /// Detection works after the first blink to make sure we have the correct
  /// minimum and maximum values.
  bool get isClose {
    if (boundingBox.height == 0) return false;
    final heightRatio = distance / boundingBox.height;
    if (heightRatio == 0) return false;

    if (_maxRatio == null || heightRatio > _maxRatio!) {
      _maxRatio = heightRatio;
    }

    if ((_minRatio == null || heightRatio < _minRatio!) && heightRatio > 0) {
      _minRatio = heightRatio;
    }

    if (_minRatio! / _maxRatio! < 0.5) {
      _firstAction = true;
    }

    if (_firstAction) {
      final percent = (heightRatio - _minRatio!) / (_maxRatio! - _minRatio!);
      return percent < _minEyeRatio;
    } else {
      return false;
    }
  }

  @override
  List<Object?> get props => [
        _eyeSide,
        _maxRatio,
        _minRatio,
        _firstAction,
        keypoints,
        boundingBox,
      ];

  @override
  void update(
    List<Keypoint> newKeypoints,
    BoundingBox newBoundingBox,
  ) {
    keypoints = newKeypoints;
    boundingBox = newBoundingBox;
  }
}
