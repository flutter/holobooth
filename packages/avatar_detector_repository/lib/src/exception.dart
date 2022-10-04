/// Exception thrown when `AvatarDetectorRepository.preloadLandmarksModel`
/// model fails.
///
/// It contains a [message] field which describes the error.
class PreloadLandmarksModelException implements Exception {
  /// Default constructor
  const PreloadLandmarksModelException(this.message);

  /// Description of the failure.
  final String message;

  @override
  String toString() => message;
}

/// Exception thrown when detectFace fails.
///
/// It contains a [message] field which describes the error.
class DetectFaceException implements Exception {
  /// Default constructor
  const DetectFaceException(this.message);

  /// Description of the failure
  final String message;

  @override
  String toString() => message;
}

/// Exception thrown if detectFace return no face.
///
class FaceNotFoundException extends DetectFaceException {
  /// Default constructor
  FaceNotFoundException(super.message);
}
