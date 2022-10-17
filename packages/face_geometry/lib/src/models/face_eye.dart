/// {@template face_eye}
/// An object which holds data for eye blink.
/// {@endtemplate}
class FaceEye {
  /// {@macro face_eye}
  FaceEye();

  double? _maxRatio;
  double? _minRatio;

  /// Define whether the first action, e.g. close, was detected and we have the
  /// correct min and max values.
  bool _firstAction = false;

  /// Detect if the eye is closed.
  /// Detection works after the first blink to make sure we have the correct
  /// minimum and maximum values.
  bool isClose({
    required double eyeDistance,
    required double boundingBoxHeight,
  }) {
    if (boundingBoxHeight == 0) return false;
    final heightRatio = eyeDistance / boundingBoxHeight;
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
      return percent < 0.3;
    } else {
      return false;
    }
  }
}
