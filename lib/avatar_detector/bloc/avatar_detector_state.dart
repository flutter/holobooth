part of 'avatar_detector_bloc.dart';

enum AvatarDetectorStatus {
  /// The tensorflow model has not been loaded and is not ready to estimate.
  initial,

  /// The tensorflow model is being loaded.
  loading,

  /// The tensorflow model has loaded.
  loaded,

  /// An error occurred while loading the tensorflow model or estimating.
  error,

  /// The tensorflow model is estimating the [Avatar] from the [CameraImage].
  estimating,

  /// The tensorflow model is warming up.
  ///
  /// Before them model reports an [Avatar] as detected, it needs to warm up to
  /// calibrate the face geometric data.
  warming,

  /// The [Avatar] has been detected.
  detected,

  /// The [Avatar] has not been detected.
  ///
  /// This occurs only when [estimating] the [Avatar] has failed for a certain
  /// amount of time, given by [AvatarDetectorBloc.undetectedDelay].
  notDetected;

  bool get hasLoadedModel =>
      this == loaded ||
      this == estimating ||
      this == detected ||
      this == notDetected ||
      this == warming;
}

class AvatarDetectorState extends Equatable {
  const AvatarDetectorState({
    this.status = AvatarDetectorStatus.initial,
    this.avatar = Avatar.zero,
    this.lastAvatarDetection,
    this.detectedAvatarCount = 0,
  });

  final AvatarDetectorStatus status;
  final Avatar avatar;
  final DateTime? lastAvatarDetection;
  final int detectedAvatarCount;

  AvatarDetectorState copyWith({
    AvatarDetectorStatus? status,
    Avatar? avatar,
    DateTime? lastAvatarDetection,
    int? detectedAvatarCount,
  }) {
    return AvatarDetectorState(
      status: status ?? this.status,
      avatar: avatar ?? this.avatar,
      lastAvatarDetection: lastAvatarDetection ?? this.lastAvatarDetection,
      detectedAvatarCount: detectedAvatarCount ?? this.detectedAvatarCount,
    );
  }

  @override
  List<Object?> get props => [
        status,
        avatar,
        lastAvatarDetection,
        detectedAvatarCount,
      ];
}
