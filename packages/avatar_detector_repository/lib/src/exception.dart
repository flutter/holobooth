/// {@template preload_landmkars_detector_repository_exception}
/// Exception thrown when `AvatarDetectorRepository.preloadLandmarksModel`
/// model fails.
/// {@endtemplate}
class PreloadLandmarksModelException implements Exception {
  /// {@macro preload_landmkars_detector_repository_exception}
  const PreloadLandmarksModelException(this.message);

  /// Description of the failure.
  final String message;

  @override
  String toString() => message;
}

/// {@template detect_face_exception}
/// Exception thrown when detectFace fails.
/// {@endtemplate}
class DetectFaceException implements Exception {
  /// {@macro detect_face_exception}
  const DetectFaceException(this.message);

  /// Description of the failure
  final String message;

  @override
  String toString() => message;
}
