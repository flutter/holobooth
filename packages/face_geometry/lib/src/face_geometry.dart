import 'dart:math' as math;

import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;

final _maxRatios = <String, double?>{'leftEye': null, 'rightEye': null};
final _minRatios = <String, double?>{'leftEye': null, 'rightEye': null};
final _aveRatios = <String, double?>{'leftEye': null, 'rightEye': null};
// Define if first action eq blink was detected and we have correct min and max
// values.
final _firstAction = <String, bool>{'leftEye': false, 'rightEye': false};

/// Set of calculations to detect common face expressions.
extension FaceGeometry on tf.Face {
  /// The distance between the top lip and the bottom lip.
  double get mouthDistance {
    if (keypoints.length < 15) return 0;
    final topLipPoint = keypoints[13];
    final bottomLipPoint = keypoints[14];
    return topLipPoint.distanceTo(bottomLipPoint);
  }

  /// The distance between the top left eye lid and the bottom left eye lid.
  double get leftEyeDistance {
    if (keypoints.length < 160) return 0;
    final topEyeLid = keypoints[159];
    final bottomEyeLid = keypoints[145];
    return topEyeLid.distanceTo(bottomEyeLid);
  }

  /// The distance between the top right eye lid and the bottom right eye lid
  double get rightEyeDistance {
    if (keypoints.length < 387) return 0;
    final topEyeLid = keypoints[386];
    final bottomEyeLid = keypoints[374];
    return topEyeLid.distanceTo(bottomEyeLid);
  }

  /// Detect if the left eye is closed.
  /// Detection works after the first blink to make sure we have the correct
  /// minimum and maximum values.
  ///
  /// Since the face is mirrored, we need to check the right eye.
  bool get isLeftEyeClose => _isEyeClose('rightEye');

  /// Detect if the right eye is closed.
  /// Detection works after the first blink to make sure we have the correct
  /// minimum and maximum values.
  ///
  /// Since the face is mirrored, we need to check the left eye.
  bool get isRightEyeClose => _isEyeClose('leftEye');

  bool _isEyeClose(String name) {
    final eyeDistance = name == 'leftEye' ? leftEyeDistance : rightEyeDistance;
    final heightRatio = eyeDistance / boundingBox.height;
    if (heightRatio == 0) return false;

    if (_maxRatios[name] == null || heightRatio > _maxRatios[name]!) {
      _maxRatios[name] = heightRatio;
    }

    if ((_minRatios[name] == null || heightRatio < _minRatios[name]!) &&
        heightRatio > 0) {
      _minRatios[name] = heightRatio;
    }

    _aveRatios[name] = (_maxRatios[name] ?? 0) - (_minRatios[name] ?? 0);

    if (_minRatios[name]! / _maxRatios[name]! < 0.5) {
      _firstAction[name] = true;
    }

    if (_firstAction[name]!) {
      final percent = (heightRatio - _minRatios[name]!) /
          (_maxRatios[name]! - _minRatios[name]!);
      return percent < 0.3;
    } else {
      return false;
    }
  }
}

extension on tf.Keypoint {
  double distanceTo(tf.Keypoint other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return math.sqrt(math.pow(dx, 2) + math.pow(dy, 2));
  }
}
