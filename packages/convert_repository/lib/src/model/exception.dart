/// {@template generate_video_exception}
/// Exception thrown when convert frames fails.
/// {@endtemplate}
class GenerateVideoException implements Exception {
  /// {@macro generate_video_exception}
  const GenerateVideoException(this.message);

  /// Description of the failure
  final String message;

  @override
  String toString() => message;
}
