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

/// {@template detect_avatar_exception}
/// Exception thrown when `AvatarDetectorRepository.detectAvatar` fails.
/// {@endtemplate}
class DetectAvatarException implements Exception {
  /// {@macro detect_avatar_exception}
  const DetectAvatarException(this.message);

  /// Description of the failure
  final String message;

  @override
  String toString() => message;
}
